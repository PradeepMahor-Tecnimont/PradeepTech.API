Create Or Replace Package Body selfservice.print_log_mis As

    Procedure generate_html As
        l_xmltype     Xmltype;
        lhtmloutput   Xmltype;
        lxsl          Clob;
        lretval       Clob;
        param_success Varchar2(60);
        param_message Varchar2(200);
    Begin
        l_xmltype   := dbms_xmlgen.getxmltype(
                           'select * from 
              (
                  select PARENT, empno, emp_name, USER_NAME, PERIOD, PAGECOUNT
                      from SS_VU_PRINT_LOG_PIVOT where parent=''' || '0106' || '''
               ) 
              pivot (sum(pagecount) for (period) in 
                  (''' ||
                           '201505_B_W' || ''' ,''' || '201505_COLOR' || ''' ,''' || '201504_B_W' || ''',''' || '201504_COLOR' ||
                           ''',
                    ''' || '201503_B_W' || ''',''' || '201503_COLOR' || ''',''' || '201502_B_W' ||
                           ''',''' || '201502_COLOR' || '''))'
                       );

        lxsl        := lxsl || q'[<?xml version="1.0" encoding="ISO-8859-1"?>]';
        lxsl        := lxsl || q'[<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">]';
        lxsl        := lxsl || q'[ <xsl:output method="html"/>]';
        lxsl        := lxsl || q'[ <xsl:template match="/">]';
        lxsl        := lxsl || q'[ <html>]';
        lxsl        := lxsl || q'[  <body>]';
        lxsl        := lxsl || q'[   <table border="1">]';
        lxsl        := lxsl || q'[     <tr bgcolor="Beige">]';
        lxsl        := lxsl || q'[      <xsl:for-each select="/ROWSET/ROW[1]/*">]';
        lxsl        := lxsl || q'[       <th><xsl:value-of select="name()"/></th>]';
        lxsl        := lxsl || q'[      </xsl:for-each>]';
        lxsl        := lxsl || q'[     </tr>]';
        lxsl        := lxsl || q'[     <xsl:for-each select="/ROWSET/*">]';
        lxsl        := lxsl || q'[      <tr>]';
        lxsl        := lxsl || q'[       <xsl:for-each select="./*">]';
        lxsl        := lxsl || q'[        <td><xsl:value-of select="text()"/> </td>]';
        lxsl        := lxsl || q'[       </xsl:for-each>]';
        lxsl        := lxsl || q'[      </tr>]';
        lxsl        := lxsl || q'[     </xsl:for-each>]';
        lxsl        := lxsl || q'[   </table>]';
        lxsl        := lxsl || q'[  </body>]';
        lxsl        := lxsl || q'[ </html>]';
        lxsl        := lxsl || q'[ </xsl:template>]';
        lxsl        := lxsl || q'[</xsl:stylesheet>]';

        -- XSL transformation to convert XML to HTML --
        lhtmloutput := l_xmltype.transform(xmltype(lxsl));
        -- convert XMLType to Clob --
        lretval     := lhtmloutput.getclobval();
        lretval     := replace(lretval, '_x0027_', '');
        ss_mail.send_html_mail('d.bhavsar@ticb.com', 'Print Log', lretval, param_success, param_message);
        dbms_output.put_line(param_success);
        dbms_output.put_line(param_message);
    End generate_html;

    Function get_page_size(param_page_size Varchar2) Return Varchar2 Is
        v_actual_page_size Varchar2(60);
    Begin
        Begin
            Select
                map_paper_size
            Into
                v_actual_page_size
            From
                (
                    Select
                    Distinct map_paper_size
                    From
                        ss_paper_size_map
                    Where
                        Trim(src_paper_size) = Trim(param_page_size)
                )
            Where
                Rownum = 1;
        Exception
            When Others Then
                v_actual_page_size := param_page_size;
        End;
        Return v_actual_page_size;
    End;

    Function get_print_rate(param_page_size  Varchar2,
                            param_color_flag Number) Return Number Is
        v_count      Number;
        v_page_size  Varchar2(60);
        v_print_rate Number;
    Begin
        v_page_size := get_page_size(param_page_size);
        Begin
            Select
                rate
            Into
                v_print_rate
            From
                ss_print_rate_mast
            Where
                page_size = Trim(v_page_size)
                And color = param_color_flag;
            Return v_print_rate;
        Exception
            When Others Then
                Return 10;
        End;
    End;
    Function get_print_rate(param_page_size  Varchar2,
                            param_color_flag Varchar2) Return Number Is
        v_count      Number;
        v_color_flag Number := 1; --Color
        v_page_size  Varchar2(60);
        v_print_rate Number;
    Begin
        If upper(trim(param_color_flag)) = 'GRAYSCALE' Then
            v_color_flag := -1; --- B/W
        End If;
        v_print_rate := get_print_rate(param_page_size, v_color_flag);
        Return v_print_rate;
    End;

    Procedure update_print_log As
        Cursor cur_print_log Is
            Select
                Rownum, userid, page_size, color
            From
                ss_print_log
            Where
                empno Is Null
                And print_date > trunc(sysdate) - 3;
        --and PRINT_DATE = to_date('17-OCT-2015','dd-MON-yyyy');
        v_empno     Varchar2(5);
        v_deptno    Varchar2(4);
        v_page_type Varchar2(2);
        v_cost      Number;
    Begin
        For cur_row In cur_print_log
        Loop
            Begin
                Select
                    empno
                Into
                    v_empno
                From
                    userids
                Where
                    domain           = 'TICB'
                    And Trim(userid) = Trim(upper(cur_row.userid));
                Select
                    parent
                Into
                    v_deptno
                From
                    ss_emplmast
                Where
                    empno = v_empno;
            Exception
                When Others Then
                    Null;
            End;
            Begin
                Select
                    map_paper_size
                Into
                    v_page_type
                From
                    ss_paper_size_map
                Where
                    Trim(src_paper_size) = Trim(upper(cur_row.page_size));
                Select
                    rate
                Into
                    v_cost
                From
                    ss_print_rate_mast
                Where
                    page_size = v_page_type
                    And color = decode(Trim(cur_row.color), 'NOT GRAYSCALE', 1, - 1);
            Exception
                When Others Then
                    Null;
            End;
            If v_empno Is Not Null Or v_cost Is Not Null Then
                Update
                    ss_print_log
                Set
                    empno = v_empno, parent = v_deptno, page_type = v_page_type, cost = v_cost
                Where
                    Rownum = cur_row.rownum;
            End If;
            Commit;
        End Loop;
        --Commit;

    End;

End print_log_mis;
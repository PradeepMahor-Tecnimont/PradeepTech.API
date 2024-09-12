--------------------------------------------------------
--  DDL for Package Body PRINT_LOG_MIS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PRINT_LOG_MIS" as

    procedure generate_html as
          l_xmltype XMLTYPE;
          lHTMLOutput xmltype;
          lXSL         CLOB;
          lRetVal      CLOB;
          param_success varchar2(60);
          param_message varchar2(200);
        begin
          l_xmltype := dbms_xmlgen.getxmltype(
              'select * from 
              (
                  select PARENT, empno, emp_name, USER_NAME, PERIOD, PAGECOUNT
                      from SS_VU_PRINT_LOG_PIVOT where parent=''' || '0106' || '''
               ) 
              pivot (sum(pagecount) for (period) in 
                  (''' || '201505_B_W' || ''' ,''' || '201505_COLOR' || ''' ,'''  || '201504_B_W' || ''',''' || '201504_COLOR' || ''',
                    ''' || '201503_B_W' || ''',''' || '201503_COLOR' || ''',''' || '201502_B_W' || ''',''' || '201502_COLOR' || '''))'
                    );
      

          lXSL := lXSL || q'[<?xml version="1.0" encoding="ISO-8859-1"?>]';
          lXSL := lXSL || q'[<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">]';
          lXSL := lXSL || q'[ <xsl:output method="html"/>]';
          lXSL := lXSL || q'[ <xsl:template match="/">]';
          lXSL := lXSL || q'[ <html>]';
          lXSL := lXSL || q'[  <body>]';
          lXSL := lXSL || q'[   <table border="1">]';
          lXSL := lXSL || q'[     <tr bgcolor="Beige">]';
          lXSL := lXSL || q'[      <xsl:for-each select="/ROWSET/ROW[1]/*">]';
          lXSL := lXSL || q'[       <th><xsl:value-of select="name()"/></th>]';
          lXSL := lXSL || q'[      </xsl:for-each>]';
          lXSL := lXSL || q'[     </tr>]';
          lXSL := lXSL || q'[     <xsl:for-each select="/ROWSET/*">]';
          lXSL := lXSL || q'[      <tr>]';    
          lXSL := lXSL || q'[       <xsl:for-each select="./*">]';
          lXSL := lXSL || q'[        <td><xsl:value-of select="text()"/> </td>]';
          lXSL := lXSL || q'[       </xsl:for-each>]';
          lXSL := lXSL || q'[      </tr>]';
          lXSL := lXSL || q'[     </xsl:for-each>]';
          lXSL := lXSL || q'[   </table>]';
          lXSL := lXSL || q'[  </body>]';
          lXSL := lXSL || q'[ </html>]';
          lXSL := lXSL || q'[ </xsl:template>]';
          lXSL := lXSL || q'[</xsl:stylesheet>]';

          -- XSL transformation to convert XML to HTML --
          lHTMLOutput := l_xmltype.transform(XMLType(lXSL));
          -- convert XMLType to Clob --
          lRetVal := lHTMLOutput.getClobVal();
          lRetVal := replace(lRetVal,'_x0027_','');
          SS_MAIL.SEND_html_MAIL('d.bhavsar@ticb.com','Print Log',lRetVal,PARAM_SUCCESS ,PARAM_MESSAGE );
          dbms_output.put_line(param_success);
          dbms_output.put_line(param_message);
      end generate_html;
      
      function get_page_size(param_page_size varchar2) return varchar2 is
          v_actual_page_size varchar2(60);
      Begin
        Begin
          Select map_paper_size into v_actual_page_size from 
                (
                    select distinct map_paper_size from SS_PAPER_SIZE_MAP 
                    where trim(SRC_PAPER_SIZE) = trim(param_page_size) 
                ) where rownum = 1;
        Exception
          When others then
            v_actual_page_size := param_page_size;
        End;
        Return v_actual_Page_size;
      End;
      
      
      
      function get_print_rate(param_page_size varchar2, param_color_flag number) return number is
          v_count number;
          v_page_size varchar2(60);
          v_print_rate number;
      Begin
          v_page_size := get_page_size(param_page_size);
          Begin
              Select  RATE into v_print_rate  from ss_print_rate_mast where PAGE_SIZE = trim(v_page_size) and COLOR = param_color_flag;
              return v_print_rate;
          Exception
            when Others then return 10;
          End;
      End;
      function get_print_rate(param_page_size varchar2, param_color_flag varchar2) return number is
          v_count number;
          v_color_flag number := 1; --Color
          v_page_size varchar2(60);
          v_print_rate number;
      Begin
          If Upper(Trim(param_color_flag)) = 'GRAYSCALE' Then
              v_color_flag := -1; --- B/W
          End If;
          v_print_rate := get_print_rate(param_page_size, v_color_flag);
          return v_print_rate;
      End;
      
      Procedure update_print_log as
          cursor cur_print_log is select rownum, userid, page_size, COLOR from ss_print_log where empno is null
            and PRINT_DATE = to_date('17-OCT-2015','dd-MON-yyyy');
          v_empno varchar2(5);
          v_deptno varchar2(4);
          v_page_type varchar2(2);
          v_cost number;
      Begin
          for cur_row in cur_print_log  loop
              begin
                select empno into v_empno from userids where domain = 'TICB' and trim(userid) = Trim(upper(cur_row.userid));
                Select parent into v_deptno from ss_emplmast where empno = v_empno;
              Exception
                When Others then null;
              end;
              begin
                  select map_paper_size into v_page_type from ss_paper_size_map where
                    trim(src_paper_size) = trim(upper(cur_row.page_size));
                  select rate into v_cost from ss_print_rate_mast where 
                    PAGE_SIZE = v_page_type and color = decode(trim(cur_row.color), 'NOT GRAYSCALE',1,-1);
              exception
                  when others then null;
              end;
              If v_empno is not null or v_cost is not null Then
                  update ss_print_log set empno = v_empno, parent = v_deptno, page_type = v_page_type, cost = v_cost
                    where rownum = cur_row.rownum;
              End If;
          end loop;
          Commit;
      
      End;
      
      
end print_log_mis;

/

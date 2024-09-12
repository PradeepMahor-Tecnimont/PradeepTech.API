--------------------------------------------------------
--  DDL for Package Body NETWORK_DATA_PRINTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."NETWORK_DATA_PRINTER" As
    Function deleteKyoceraCanonData(pEntryDate Varchar2) Return Number Is
    Begin                      
        updatePrinterQueue(pEntryDate);
        deleteDuplicateData(pEntryDate);                       

        Delete From ss_pagecount_canon 
            Where entry_date = pEntryDate 
            And prn_queue In (Select prn_queue From ss_pagecount_canon
                              Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
                              And entry_date < pEntryDate
                              And prn_online = 1);

        Delete From ss_pagecount_kyocer 
            Where entry_date = pEntryDate 
            And prn_queue In (Select prn_queue From ss_pagecount_kyocer
                              Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
                              And entry_date < pEntryDate
                              And prn_online = 1);


        Delete From ss_pagecount_canon 
            Where entry_date = pEntryDate 
            And prn_online = -1
            And prn_queue In (Select prn_queue From ss_pagecount_canon
                              Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
                              And entry_date < pEntryDate
                              And prn_online = -1);

        Delete From ss_pagecount_kyocer 
            Where entry_date = pEntryDate 
            And prn_online = -1
            And prn_queue In (Select prn_queue From ss_pagecount_kyocer
                              Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
                              And entry_date < pEntryDate
                              And prn_online = -1);

        Delete From ss_pagecount_canon 
            Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
            And entry_date < pEntryDate
            And prn_online = -1
            And prn_queue In (Select prn_queue From ss_pagecount_canon
                              Where entry_date = pEntryDate
                              And prn_online = 1);

        Delete From ss_pagecount_kyocer 
            Where Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) 
            And entry_date < pEntryDate
            And prn_online = -1
            And prn_queue In (Select prn_queue From ss_pagecount_kyocer 
                              Where entry_date = pEntryDate
                              And prn_online = 1);                              

        Commit;
        Return 1;
    End;

    Function getKyoceraCanonDailyData(pEntryDate Varchar2) Return Number Is
        nCountCanon Number:=0;
        nCountKyocera Number:=0;
        nCountCanonErr Number:=0;
        nCountKyoceraErr Number:=0;
    Begin      
        Select Count(*) Into nCountCanonErr From ss_pagecount_canon Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = pEntryDate;
        Select Count(*) Into nCountKyoceraErr From ss_pagecount_kyocer Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = pEntryDate;
        If nCountCanonErr > 0 Or nCountKyoceraErr > 0 Then
            sendDataErrorMail(pEntryDate);
            Insert Into ss_pagecount_canon_errors
                Select * From ss_pagecount_canon
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Delete From ss_pagecount_canon 
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Insert Into ss_pagecount_kyocer_errors
                Select * From ss_pagecount_kyocer
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Delete From ss_pagecount_kyocer 
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Commit;                    
        End If;        

        Begin
            Select Count(prn_queue) Into nCountCanon From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1;
        Exception
            When No_Data_Found Then
                nCountCanon:=0;
            When Others Then
                nCountCanon:=1;
        End;
        Begin
            Select Count(prn_queue) Into nCountKyocera From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1;
        Exception
            When No_Data_Found Then
                nCountKyocera:=0;
            When Others Then
                nCountKyocera:=1;
        End;            
        If nCountCanon = 0 And nCountKyocera = 0 Then
            getCanonData(pEntryDate);
            getKyoceraData(pEntryDate);            
            If getCanonKyoceraRecords(pEntryDate) > 0 Then
                sendMail(pEntryDate);
            End If;
            If nCountCanonErr > 0 Or nCountKyoceraErr > 0 Then
                Return 0;
            Else
                Return 1;
            End If;
        Else
            sendDuplicateMail(pEntryDate);
            Insert Into ss_pagecount_canon_errors
                Select * From ss_pagecount_canon
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Delete From ss_pagecount_canon 
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Insert Into ss_pagecount_kyocer_errors
                Select * From ss_pagecount_kyocer
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Delete From ss_pagecount_kyocer 
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Commit;            
            getCanonData(pEntryDate);
            getKyoceraData(pEntryDate);
            If getCanonKyoceraRecords(pEntryDate) > 0 Then
                sendMail(pEntryDate);
            End If;
            Return 0;
        End If;        
    End;

    Function deleteKyoceraCanonDataOld(pEntryDate Varchar2) Return Number Is
    Begin
        Delete From ss_pagecount_canon Where manual_entry_id Is Null And Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) And entry_date < pEntryDate;
        Delete From ss_pagecount_kyocer Where manual_entry_id Is Null And Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) And entry_date < pEntryDate;
        Commit;
        Return 1;
    End;

    Function getKyoceraCanonDailyDataOld(pEntryDate Varchar2) Return Number Is
        nCountCanon Number:=0;
        nCountKyocera Number:=0;
        nCountCanonErr Number:=0;
        nCountKyoceraErr Number:=0;
    Begin               
        updatePrinterQueue(pEntryDate);
        deleteDuplicateData(pEntryDate);

        Select Count(*) Into nCountCanonErr From ss_pagecount_canon Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = pEntryDate;
        Select Count(*) Into nCountKyoceraErr From ss_pagecount_kyocer Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = pEntryDate;
        If nCountCanonErr > 0 Or nCountKyoceraErr > 0 Then
            sendDataErrorMail(pEntryDate);
            Insert Into ss_pagecount_canon_errors
                Select * From ss_pagecount_canon
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Delete From ss_pagecount_canon 
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Insert Into ss_pagecount_kyocer_errors
                Select * From ss_pagecount_kyocer
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Delete From ss_pagecount_kyocer 
                Where entry_date = pEntryDate 
                And (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR');
            Commit;                    
        End If;        

        Begin
            Select Count(prn_queue) Into nCountCanon From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1;
        Exception
            When No_Data_Found Then
                nCountCanon:=0;
            When Others Then
                nCountCanon:=1;
        End;
        Begin
            Select Count(prn_queue) Into nCountKyocera From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1;
        Exception
            When No_Data_Found Then
                nCountKyocera:=0;
            When Others Then
                nCountKyocera:=1;
        End;            
        If nCountCanon = 0 And nCountKyocera = 0 Then
            getCanonData(pEntryDate);
            getKyoceraData(pEntryDate);
            sendMail(pEntryDate);
            If nCountCanonErr > 0 Or nCountKyoceraErr > 0 Then
                Return 0;
            Else
                Return 1;
            End If;
        Else
            sendDuplicateMail(pEntryDate);
            Insert Into ss_pagecount_canon_errors
                Select * From ss_pagecount_canon
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Delete From ss_pagecount_canon 
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_canon Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Insert Into ss_pagecount_kyocer_errors
                Select * From ss_pagecount_kyocer
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Delete From ss_pagecount_kyocer 
                Where entry_date = pEntryDate 
                And prn_queue In (Select prn_queue From ss_pagecount_kyocer Where prn_online = 1 And entry_date = pEntryDate Group by prn_queue Having count(prn_queue) > 1);
            Commit;            
            getCanonData(pEntryDate);
            getKyoceraData(pEntryDate);
            sendMail(pEntryDate);
            Return 0;
        End If;
    End;

    Procedure deleteDuplicateData(pEntryDates Varchar2) Is
    Begin        
        Delete From ss_pagecount_canon a
          Where a.rowid > Any (select b.rowid From ss_pagecount_canon b Where b.entry_date = pEntryDates And a.entry_date = b.entry_date And a.ipaddress = b.ipaddress And a.prn_queue = b.prn_queue);
        Delete From ss_pagecount_kyocer a
          Where a.rowid > Any (select b.rowid From ss_pagecount_kyocer b Where b.entry_date = pEntryDates And a.entry_date = b.entry_date And a.ipaddress = b.ipaddress And a.prn_queue = b.prn_queue);         
       Commit;   
    End;

    Procedure getCanonData(pEntryDate Varchar2) Is
        nTotalPreviousDay ss_pagecount_canon.total%type;
        nBlackLargePreviousDay ss_pagecount_canon.blacklarge%type;
        nBlackSmallPreviousDay ss_pagecount_canon.blacksmall%type;
        nColorLargePreviousDay ss_pagecount_canon.colorlarge%type;
        nColorSmallPreviousDay ss_pagecount_canon.colorsmall%type;
        nTotal2SidedPreviousDay ss_pagecount_canon.total2sided%type;
        nTotal2PreviousDay ss_pagecount_canon.total2%type;              

        Cursor cur_canon Is 
            Select prn_queue, Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2
            From Ss_Pagecount_Canon 
            Where manual_entry_id Is Null            
            And entry_Date = pEntryDate  
            And prn_online = 1
            For Update Of total_daily, blacklarge_daily, blacksmall_daily, colorlarge_daily, colorsmall_daily, total2sided_daily, total2_daily;
        Cursor cur_canon_manual Is 
            Select prn_queue, Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2, manual_entry_id, prn_online
            From Ss_Pagecount_Canon_manual
            Where entry_Date = pEntryDate
            For Update Of total_daily, blacklarge_daily, blacksmall_daily, colorlarge_daily, colorsmall_daily, total2sided_daily, total2_daily;
        Cursor cur_canon_srno Is 
            Select srno, Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2
            From Ss_Pagecount_Canon 
            Where manual_entry_id Is Null            
            And entry_Date = pEntryDate  
            And prn_online = 1
            For Update Of total_daily_srno, blacklarge_daily_srno, blacksmall_daily_srno, colorlarge_daily_srno, colorsmall_daily_srno, total2sided_daily_srno, total2_daily_srno;
        Cursor cur_canon_manual_srno Is 
            Select srno, Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2, manual_entry_id, prn_online
            From Ss_Pagecount_Canon_manual
            Where entry_Date = pEntryDate
            For Update Of total_daily_srno, blacklarge_daily_srno, blacksmall_daily_srno, colorlarge_daily_srno, colorsmall_daily_srno, total2sided_daily_srno, total2_daily_srno;            
    Begin
        For c1 In cur_canon Loop
            Begin
                Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                    Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                    nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                    From Ss_Pagecount_Canon 
                    Where prn_queue = Trim(c1.prn_queue)                    
                    And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where prn_queue = Trim(c1.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                    And prn_online = 1;

                Update ss_pagecount_canon
                Set total_daily = makeZero(c1.total-nTotalPreviousDay),
                    blacklarge_daily = makeZero(c1.blacklarge-nBlackLargePreviousDay),
                    blacksmall_daily = makeZero(c1.blacksmall-nBlackSmallPreviousDay),
                    colorlarge_daily = makeZero(c1.colorlarge-nColorLargePreviousDay),
                    colorsmall_daily = makeZero(c1.colorsmall-nColorSmallPreviousDay),
                    total2sided_daily = makeZero(c1.total2sided-nTotal2SidedPreviousDay),
                    total2_daily = makeZero(c1.total2-nTotal2PreviousDay)
                Where current of cur_canon;    
            Exception
                When No_Data_Found Then
                    Begin
                        Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                            Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                            nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                            From Ss_Pagecount_Canon_manual
                            Where prn_queue = Trim(c1.prn_queue)                    
                            And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where prn_queue = Trim(c1.prn_queue) And entry_Date < pEntryDate And prn_online = 1);                            

                        Update ss_pagecount_canon
                        Set total_daily = c1.total-nTotalPreviousDay,
                            blacklarge_daily = c1.blacklarge-nBlackLargePreviousDay,
                            blacksmall_daily = c1.blacksmall-nBlackSmallPreviousDay,
                            colorlarge_daily = c1.colorlarge-nColorLargePreviousDay,
                            colorsmall_daily = c1.colorsmall-nColorSmallPreviousDay,
                            total2sided_daily = c1.total2sided-nTotal2SidedPreviousDay,
                            total2_daily = c1.total2-nTotal2PreviousDay
                        Where current of cur_canon;
                    Exception
                        When No_Data_Found Then
                          Null;
                    End;
            End;                                
        End Loop;

        For c2 In cur_canon_manual Loop
            Begin
                Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                    nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                    From ss_pagecount_canon
                    Where manual_entry_id = c2.manual_entry_id
                    And prn_online = 1;     

                Update ss_pagecount_canon
                Set total_daily = nTotalPreviousDay-c2.total,
                    blacklarge_daily = nBlackLargePreviousDay-c2.blacklarge,
                    blacksmall_daily = nBlackSmallPreviousDay-c2.blacksmall,
                    colorlarge_daily = nColorLargePreviousDay-c2.colorlarge,
                    colorsmall_daily = nColorSmallPreviousDay-c2.colorsmall,
                    total2sided_daily = nTotal2SidedPreviousDay-c2.total2sided,
                    total2_daily = nTotal2PreviousDay-c2.total2
                Where manual_entry_id = c2.manual_entry_id;

            Exception
                When No_Data_Found Then
                    Begin
                        Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                            Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                            nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                            From ss_pagecount_canon
                            Where prn_queue = Trim(c2.prn_queue)                    
                            And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where prn_queue = Trim(c2.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                            And prn_online = 1;

                        Update ss_pagecount_canon_manual
                            Set total_daily = c2.total-nTotalPreviousDay,
                                blacklarge_daily = c2.blacklarge-nBlackLargePreviousDay,
                                blacksmall_daily = c2.blacksmall-nBlackSmallPreviousDay,
                                colorlarge_daily = c2.colorlarge-nColorLargePreviousDay,
                                colorsmall_daily = c2.colorsmall-nColorSmallPreviousDay,
                                total2sided_daily = c2.total2sided-nTotal2SidedPreviousDay,
                                total2_daily = c2.total2-nTotal2PreviousDay
                            Where current of cur_canon_manual;  
                      Exception
                          When No_Data_Found Then
                              Null;
                      End;
            End;
        End Loop;

        For c3 In cur_canon_srno Loop
            Begin
                Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                    Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                    nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                    From Ss_Pagecount_Canon 
                    Where srno = Trim(c3.srno)                    
                    And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where srno = Trim(c3.srno) And entry_Date < pEntryDate And prn_online = 1)
                    And prn_online = 1;

                Update ss_pagecount_canon
                Set total_daily_srno = makeZero(c3.total-nTotalPreviousDay),
                    blacklarge_daily_srno = makeZero(c3.blacklarge-nBlackLargePreviousDay),
                    blacksmall_daily_srno = makeZero(c3.blacksmall-nBlackSmallPreviousDay),
                    colorlarge_daily_srno = makeZero(c3.colorlarge-nColorLargePreviousDay),
                    colorsmall_daily_srno = makeZero(c3.colorsmall-nColorSmallPreviousDay),
                    total2sided_daily_srno = makeZero(c3.total2sided-nTotal2SidedPreviousDay),
                    total2_daily_srno = makeZero(c3.total2-nTotal2PreviousDay)
                Where current of cur_canon_srno;    
            Exception
                When No_Data_Found Then
                    Begin
                        Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                            Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                            nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                            From Ss_Pagecount_Canon_manual
                            Where srno = Trim(c3.srno)                    
                            And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where srno = Trim(c3.srno) And entry_Date < pEntryDate And prn_online = 1);                            

                        Update ss_pagecount_canon
                        Set total_daily_srno = c3.total-nTotalPreviousDay,
                            blacklarge_daily_srno = c3.blacklarge-nBlackLargePreviousDay,
                            blacksmall_daily_srno = c3.blacksmall-nBlackSmallPreviousDay,
                            colorlarge_daily_srno = c3.colorlarge-nColorLargePreviousDay,
                            colorsmall_daily_srno = c3.colorsmall-nColorSmallPreviousDay,
                            total2sided_daily_srno = c3.total2sided-nTotal2SidedPreviousDay,
                            total2_daily_srno = c3.total2-nTotal2PreviousDay
                        Where current of cur_canon_srno;
                    Exception
                        When No_Data_Found Then
                          Null;
                    End;
            End;                                
        End Loop;        

        For c4 In cur_canon_manual_srno Loop
            Begin
                Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                    nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                    From ss_pagecount_canon
                    Where manual_entry_id = c4.manual_entry_id
                    And prn_online = 1;     

                Update ss_pagecount_canon
                Set total_daily_srno = nTotalPreviousDay-c4.total,
                    blacklarge_daily_srno = nBlackLargePreviousDay-c4.blacklarge,
                    blacksmall_daily_srno = nBlackSmallPreviousDay-c4.blacksmall,
                    colorlarge_daily_srno = nColorLargePreviousDay-c4.colorlarge,
                    colorsmall_daily_srno = nColorSmallPreviousDay-c4.colorsmall,
                    total2sided_daily_srno = nTotal2SidedPreviousDay-c4.total2sided,
                    total2_daily_srno = nTotal2PreviousDay-c4.total2
                Where manual_entry_id = c4.manual_entry_id;

            Exception
                When No_Data_Found Then
                    Begin
                        Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                            Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                            nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                            From ss_pagecount_canon
                            Where srno = Trim(c4.srno)                    
                            And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where srno = Trim(c4.srno) And entry_Date < pEntryDate And prn_online = 1)
                            And prn_online = 1;

                        Update ss_pagecount_canon_manual
                            Set total_daily_srno = c4.total-nTotalPreviousDay,
                                blacklarge_daily_srno = c4.blacklarge-nBlackLargePreviousDay,
                                blacksmall_daily_srno = c4.blacksmall-nBlackSmallPreviousDay,
                                colorlarge_daily_srno = c4.colorlarge-nColorLargePreviousDay,
                                colorsmall_daily_srno = c4.colorsmall-nColorSmallPreviousDay,
                                total2sided_daily_srno = c4.total2sided-nTotal2SidedPreviousDay,
                                total2_daily_srno = c4.total2-nTotal2PreviousDay
                            Where current of cur_canon_manual_srno;  
                      Exception
                          When No_Data_Found Then
                              Null;
                      End;
            End;
        End Loop;        
        Commit;        
    End;  

    Procedure getKyoceraData(pEntryDate Varchar2) Is
        nTot_A3PreviousDay ss_pagecount_kyocer.Tot_A3%type;
        nTot_B4PreviousDay ss_pagecount_kyocer.Tot_B4%type;
        nTot_A4PreviousDay ss_pagecount_kyocer.Tot_A4%type;
        nTot_B5PreviousDay ss_pagecount_kyocer.Tot_B5%type;
        nTot_A5PreviousDay ss_pagecount_kyocer.Tot_A5%type;
        nTot_FolioPreviousDay ss_pagecount_kyocer.Tot_Folio%type;
        nTot_LedgerPreviousDay ss_pagecount_kyocer.Tot_Ledger%type;
        nTot_LegalPreviousDay ss_pagecount_kyocer.Tot_Legal%type;
        nTot_LetterPreviousDay ss_pagecount_kyocer.Tot_Letter%type;
        nTot_StatementPreviousDay ss_pagecount_kyocer.Tot_Statement%type;
        nTot_Banner1PreviousDay ss_pagecount_kyocer.Tot_Banner1%type;
        nTot_Banner2PreviousDay ss_pagecount_kyocer.Tot_Banner2%type;
        nTot_Other1PreviousDay ss_pagecount_kyocer.Tot_Other1%type;
        nTot_Other2PreviousDay ss_pagecount_kyocer.Tot_Other2%type;
        nBW_A3PreviousDay ss_pagecount_kyocer.BW_A3%type;
        nBW_B4PreviousDay ss_pagecount_kyocer.BW_B4%type;
        nBW_A4PreviousDay ss_pagecount_kyocer.BW_A4%type;
        nBW_B5PreviousDay ss_pagecount_kyocer.BW_B5%type;
        nBW_A5PreviousDay ss_pagecount_kyocer.BW_A5%type;
        nBW_FolioPreviousDay ss_pagecount_kyocer.BW_Folio%type;
        nBW_LedgerPreviousDay ss_pagecount_kyocer.BW_Ledger%type;
        nBW_LegalPreviousDay ss_pagecount_kyocer.BW_Legal%type;
        nBW_LetterPreviousDay ss_pagecount_kyocer.BW_Letter%type;
        nBW_StatementPreviousDay ss_pagecount_kyocer.BW_Statement%type;
        nBW_Banner1PreviousDay ss_pagecount_kyocer.BW_Banner1%type;
        nBW_Banner2PreviousDay ss_pagecount_kyocer.BW_Banner2%type;
        nBW_Other1PreviousDay ss_pagecount_kyocer.BW_Other1%type;
        nBW_Other2PreviousDay ss_pagecount_kyocer.BW_Other2%type;
        nColor_A3PreviousDay ss_pagecount_kyocer.Color_A3%type;
        nColor_B4PreviousDay ss_pagecount_kyocer.Color_B4%type;
        nColor_A4PreviousDay ss_pagecount_kyocer.Color_A4%type;
        nColor_B5PreviousDay ss_pagecount_kyocer.Color_B5%type;
        nColor_A5PreviousDay ss_pagecount_kyocer.Color_A5%type;
        nColor_FolioPreviousDay ss_pagecount_kyocer.Color_Folio%type;
        nColor_LedgerPreviousDay ss_pagecount_kyocer.Color_Ledger%type;
        nColor_LegalPreviousDay ss_pagecount_kyocer.Color_Legal%type;
        nColor_LetterPreviousDay ss_pagecount_kyocer.Color_Letter%type;
        nColor_StatementPreviousDay ss_pagecount_kyocer.color_statement%type;
        nColor_Banner1PreviousDay ss_pagecount_kyocer.color_banner1%type;
        nColor_Banner2PreviousDay ss_pagecount_kyocer.color_banner2%type;
        nColor_Other1PreviousDay ss_pagecount_kyocer.color_other1%type;
        nColor_Other2PreviousDay ss_pagecount_kyocer.color_other2%type;  

        Cursor cur_kyocera Is 
            Select prn_queue, Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
            Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
            Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
            Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
            Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
            Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
            Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 
            From Ss_Pagecount_kyocer 
            Where manual_entry_id Is Null             
            And entry_Date = pEntryDate
            And prn_online = 1  
            For Update Of tot_a3_daily, tot_b4_daily, tot_a4_daily, tot_b5_daily, tot_a5_daily, tot_folio_daily, tot_ledger_daily, tot_legal_daily, tot_letter_daily,
                          tot_statement_daily, tot_banner1_daily, tot_banner2_daily, tot_other1_daily, tot_other2_daily, bw_a3_daily, bw_b4_daily, bw_a4_daily, bw_b5_daily,
                          bw_a5_daily, bw_folio_daily, bw_ledger_daily, bw_legal_daily, bw_letter_daily, bw_statement_daily, bw_banner1_daily, bw_banner2_daily, bw_other1_daily,
                          bw_other2_daily, color_a3_daily, color_b4_daily, color_a4_daily, color_b5_daily, color_a5_daily, color_folio_daily, color_ledger_daily, color_legal_daily,
                          color_letter_daily, color_statement_daily, color_banner1_daily, color_banner2_daily, color_other1_daily, color_other2_daily;
        Cursor cur_kyocera_manual Is 
            Select prn_queue, Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
            Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
            Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
            Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
            Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
            Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
            Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2, manual_entry_id, prn_online 
            From Ss_Pagecount_kyocer_manual 
            Where entry_Date = pEntryDate            
            For Update Of tot_a3_daily, tot_b4_daily, tot_a4_daily, tot_b5_daily, tot_a5_daily, tot_folio_daily, tot_ledger_daily, tot_legal_daily, tot_letter_daily,
                          tot_statement_daily, tot_banner1_daily, tot_banner2_daily, tot_other1_daily, tot_other2_daily, bw_a3_daily, bw_b4_daily, bw_a4_daily, bw_b5_daily,
                          bw_a5_daily, bw_folio_daily, bw_ledger_daily, bw_legal_daily, bw_letter_daily, bw_statement_daily, bw_banner1_daily, bw_banner2_daily, bw_other1_daily,
                          bw_other2_daily, color_a3_daily, color_b4_daily, color_a4_daily, color_b5_daily, color_a5_daily, color_folio_daily, color_ledger_daily, color_legal_daily,
                          color_letter_daily, color_statement_daily, color_banner1_daily, color_banner2_daily, color_other1_daily, color_other2_daily;
        Cursor cur_kyocera_srno Is 
            Select srno, Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
            Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
            Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
            Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
            Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
            Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
            Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 
            From Ss_Pagecount_kyocer 
            Where manual_entry_id Is Null             
            And entry_Date = pEntryDate
            And prn_online = 1  
            For Update Of tot_a3_daily_srno, tot_b4_daily_srno, tot_a4_daily_srno, tot_b5_daily_srno, tot_a5_daily_srno, tot_folio_daily_srno, tot_ledger_daily_srno, tot_legal_daily_srno, tot_letter_daily_srno,
                          tot_statement_daily_srno, tot_banner1_daily_srno, tot_banner2_daily_srno, tot_other1_daily_srno, tot_other2_daily_srno, bw_a3_daily_srno, bw_b4_daily_srno, bw_a4_daily_srno, bw_b5_daily_srno,
                          bw_a5_daily_srno, bw_folio_daily_srno, bw_ledger_daily_srno, bw_legal_daily_srno, bw_letter_daily_srno, bw_statement_daily_srno, bw_banner1_daily_srno, bw_banner2_daily_srno, bw_other1_daily_srno,
                          bw_other2_daily_srno, color_a3_daily_srno, color_b4_daily_srno, color_a4_daily_srno, color_b5_daily_srno, color_a5_daily_srno, color_folio_daily_srno, color_ledger_daily_srno, color_legal_daily_srno,
                          color_letter_daily_srno, color_statement_daily_srno, color_banner1_daily_srno, color_banner2_daily_srno, color_other1_daily_srno, color_other2_daily_srno;
        Cursor cur_kyocera_manual_srno Is 
            Select srno, Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
            Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
            Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
            Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
            Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
            Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
            Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2, manual_entry_id, prn_online 
            From Ss_Pagecount_kyocer_manual 
            Where entry_Date = pEntryDate            
            For Update Of tot_a3_daily_srno, tot_b4_daily_srno, tot_a4_daily_srno, tot_b5_daily_srno, tot_a5_daily_srno, tot_folio_daily_srno, tot_ledger_daily_srno, tot_legal_daily_srno, tot_letter_daily_srno,
                          tot_statement_daily_srno, tot_banner1_daily_srno, tot_banner2_daily_srno, tot_other1_daily_srno, tot_other2_daily_srno, bw_a3_daily_srno, bw_b4_daily_srno, bw_a4_daily_srno, bw_b5_daily_srno,
                          bw_a5_daily_srno, bw_folio_daily_srno, bw_ledger_daily_srno, bw_legal_daily_srno, bw_letter_daily_srno, bw_statement_daily_srno, bw_banner1_daily_srno, bw_banner2_daily_srno, bw_other1_daily_srno,
                          bw_other2_daily_srno, color_a3_daily_srno, color_b4_daily_srno, color_a4_daily_srno, color_b5_daily_srno, color_a5_daily_srno, color_folio_daily_srno, color_ledger_daily_srno, color_legal_daily_srno,
                          color_letter_daily_srno, color_statement_daily_srno, color_banner1_daily_srno, color_banner2_daily_srno, color_other1_daily_srno, color_other2_daily_srno;                                                   
    Begin
        For c1 In cur_kyocera Loop        
            Begin
                Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                    Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                    Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                    Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                    Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                    Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                    Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                    nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                    nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                    nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                    nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                    nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                    From Ss_Pagecount_kyocer 
                    Where prn_queue = Trim(c1.prn_queue)
                    And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where prn_queue = Trim(c1.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                    And prn_online = 1;

                Update ss_pagecount_kyocer
                Set tot_a3_daily = makeZero(c1.tot_a3 - nTot_A3PreviousDay),
                    tot_b4_daily = makeZero(c1.tot_b4 - nTot_B4PreviousDay),
                    tot_a4_daily = makeZero(c1.tot_a4 - nTot_A4PreviousDay),
                    tot_b5_daily = makeZero(c1.tot_b5 - nTot_B5PreviousDay),
                    tot_a5_daily = makeZero(c1.tot_a5 - nTot_A5PreviousDay),
                    tot_folio_daily = makeZero(c1.tot_folio - nTot_FolioPreviousDay),
                    tot_ledger_daily = makeZero(c1.tot_ledger - nTot_LedgerPreviousDay),
                    tot_legal_daily = makeZero(c1.tot_legal - nTot_LegalPreviousDay),
                    tot_letter_daily = makeZero(c1.tot_letter - nTot_LetterPreviousDay),
                    tot_statement_daily = makeZero(c1.tot_statement - nTot_StatementPreviousDay),
                    tot_banner1_daily = makeZero(c1.tot_banner1 - nTot_Banner1PreviousDay),
                    tot_banner2_daily = makeZero(c1.tot_banner2 - nTot_Banner2PreviousDay),
                    tot_other1_daily = makeZero(c1.tot_other1 - nTot_Other1PreviousDay),
                    tot_other2_daily = makeZero(c1.tot_other2 - nTot_Other2PreviousDay),
                    bw_a3_daily = makeZero(c1.bw_a3 - nBW_A3PreviousDay),
                    bw_b4_daily = makeZero(c1.bw_b4 - nBW_B4PreviousDay),
                    bw_a4_daily = makeZero(c1.bw_a4 - nBW_A4PreviousDay),
                    bw_b5_daily = makeZero(c1.bw_b5 - nBW_B5PreviousDay),
                    bw_a5_daily = makeZero(c1.bw_a5 - nBW_A5PreviousDay),
                    bw_folio_daily = makeZero(c1.bw_folio - nBW_FolioPreviousDay),
                    bw_ledger_daily = makeZero(c1.bw_ledger - nBW_LedgerPreviousDay),
                    bw_legal_daily = makeZero(c1.bw_legal - nBW_LegalPreviousDay),
                    bw_letter_daily = makeZero(c1.bw_letter - nBW_LetterPreviousDay),
                    bw_statement_daily = makeZero(c1.bw_statement - nBW_StatementPreviousDay),
                    bw_banner1_daily = makeZero(c1.bw_banner1 - nBW_Banner1PreviousDay),
                    bw_banner2_daily = makeZero(c1.bw_banner2 - nBW_Banner2PreviousDay),
                    bw_other1_daily = makeZero(c1.bw_other1 - nBW_Other1PreviousDay),
                    bw_other2_daily = makeZero(c1.bw_other2 - nBW_Other2PreviousDay),
                    color_a3_daily = makeZero(c1.color_a3 - nColor_A3PreviousDay),
                    color_b4_daily = makeZero(c1.color_b4 - nColor_B4PreviousDay),
                    color_a4_daily = makeZero(c1.color_a4 - nColor_A4PreviousDay),
                    color_b5_daily = makeZero(c1.color_b5 - nColor_B5PreviousDay),
                    color_a5_daily = makeZero(c1.color_a5 - nColor_A5PreviousDay),
                    color_folio_daily = makeZero(c1.color_folio - nColor_FolioPreviousDay),
                    color_ledger_daily = makeZero(c1.color_ledger - nColor_LedgerPreviousDay),
                    color_legal_daily = makeZero(c1.color_legal - nColor_LegalPreviousDay),
                    color_letter_daily = makeZero(c1.color_letter - nColor_LetterPreviousDay),
                    color_statement_daily = makeZero(c1.color_statement - nColor_StatementPreviousDay),
                    color_banner1_daily = makeZero(c1.color_banner1 - nColor_Banner1PreviousDay),
                    color_banner2_daily = makeZero(c1.color_banner2 - nColor_Banner2PreviousDay),
                    color_other1_daily = makeZero(c1.color_other1 - nColor_Other1PreviousDay),
                    color_other2_daily = makeZero(c1.color_other2 - nColor_Other2PreviousDay)
                Where Current Of cur_kyocera;
          Exception
              When No_Data_Found Then
                  Begin
                      Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                          Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                          Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                          Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                          Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                          Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                          Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                          nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                          nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                          nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                          nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                          nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                          From Ss_Pagecount_kyocer_manual
                          Where prn_queue = Trim(c1.prn_queue)
                          And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where prn_queue = Trim(c1.prn_queue) And entry_Date < pEntryDate And prn_online = 1);

                      Update ss_pagecount_kyocer
                      Set tot_a3_daily = c1.tot_a3 - nTot_A3PreviousDay,
                          tot_b4_daily = c1.tot_b4 - nTot_B4PreviousDay,
                          tot_a4_daily = c1.tot_a4 - nTot_A4PreviousDay,
                          tot_b5_daily = c1.tot_b5 - nTot_B5PreviousDay,
                          tot_a5_daily = c1.tot_a5 - nTot_A5PreviousDay,
                          tot_folio_daily = c1.tot_folio - nTot_FolioPreviousDay,
                          tot_ledger_daily = c1.tot_ledger - nTot_LedgerPreviousDay,
                          tot_legal_daily = c1.tot_legal - nTot_LegalPreviousDay,
                          tot_letter_daily = c1.tot_letter - nTot_LetterPreviousDay,
                          tot_statement_daily = c1.tot_statement - nTot_StatementPreviousDay,
                          tot_banner1_daily = c1.tot_banner1 - nTot_Banner1PreviousDay,
                          tot_banner2_daily = c1.tot_banner2 - nTot_Banner2PreviousDay,
                          tot_other1_daily = c1.tot_other1 - nTot_Other1PreviousDay,
                          tot_other2_daily = c1.tot_other2 - nTot_Other2PreviousDay,
                          bw_a3_daily = c1.bw_a3 - nBW_A3PreviousDay,
                          bw_b4_daily = c1.bw_b4 - nBW_B4PreviousDay,
                          bw_a4_daily = c1.bw_a4 - nBW_A4PreviousDay,
                          bw_b5_daily = c1.bw_b5 - nBW_B5PreviousDay,
                          bw_a5_daily = c1.bw_a5 - nBW_A5PreviousDay,
                          bw_folio_daily = c1.bw_folio - nBW_FolioPreviousDay,
                          bw_ledger_daily = c1.bw_ledger - nBW_LedgerPreviousDay,
                          bw_legal_daily = c1.bw_legal - nBW_LegalPreviousDay,
                          bw_letter_daily = c1.bw_letter - nBW_LetterPreviousDay,
                          bw_statement_daily = c1.bw_statement - nBW_StatementPreviousDay,
                          bw_banner1_daily = c1.bw_banner1 - nBW_Banner1PreviousDay,
                          bw_banner2_daily = c1.bw_banner2 - nBW_Banner2PreviousDay,
                          bw_other1_daily = c1.bw_other1 - nBW_Other1PreviousDay,
                          bw_other2_daily = c1.bw_other2 - nBW_Other2PreviousDay,
                          color_a3_daily = c1.color_a3 - nColor_A3PreviousDay,
                          color_b4_daily = c1.color_b4 - nColor_B4PreviousDay,
                          color_a4_daily = c1.color_a4 - nColor_A4PreviousDay,
                          color_b5_daily = c1.color_b5 - nColor_B5PreviousDay,
                          color_a5_daily = c1.color_a5 - nColor_A5PreviousDay,
                          color_folio_daily = c1.color_folio - nColor_FolioPreviousDay,
                          color_ledger_daily = c1.color_ledger - nColor_LedgerPreviousDay,
                          color_legal_daily = c1.color_legal - nColor_LegalPreviousDay,
                          color_letter_daily = c1.color_letter - nColor_LetterPreviousDay,
                          color_statement_daily = c1.color_statement - nColor_StatementPreviousDay,
                          color_banner1_daily = c1.color_banner1 - nColor_Banner1PreviousDay,
                          color_banner2_daily = c1.color_banner2 - nColor_Banner2PreviousDay,
                          color_other1_daily = c1.color_other1 - nColor_Other1PreviousDay,
                          color_other2_daily = c1.color_other2 - nColor_Other2PreviousDay 
                      Where Current Of cur_kyocera;
                  Exception
                      When No_Data_Found Then
                          Null;
                  End;
            End; 
        End Loop;

        For c2 In cur_kyocera_manual Loop        
            Begin
                Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                    Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                    Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                    Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                    Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                    Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                    Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                    nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                    nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                    nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                    nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                    nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                    From Ss_Pagecount_kyocer 
                    Where manual_entry_id = c2.manual_entry_id                    
                    And prn_online = 1;

                Update ss_pagecount_kyocer
                Set tot_a3_daily = nTot_A3PreviousDay - c2.tot_a3,
                    tot_b4_daily = nTot_B4PreviousDay - c2.tot_b4,
                    tot_a4_daily = nTot_A4PreviousDay - c2.tot_a4,
                    tot_b5_daily = nTot_B5PreviousDay - c2.tot_b5,
                    tot_a5_daily = nTot_A5PreviousDay - c2.tot_a5,
                    tot_folio_daily = nTot_FolioPreviousDay - c2.tot_folio,
                    tot_ledger_daily = nTot_LedgerPreviousDay - c2.tot_ledger,
                    tot_legal_daily = nTot_LegalPreviousDay - c2.tot_legal,
                    tot_letter_daily = nTot_LetterPreviousDay - c2.tot_letter,
                    tot_statement_daily = nTot_StatementPreviousDay - c2.tot_statement,
                    tot_banner1_daily = nTot_Banner1PreviousDay - c2.tot_banner1,
                    tot_banner2_daily = nTot_Banner2PreviousDay - c2.tot_banner2,
                    tot_other1_daily = nTot_Other1PreviousDay - c2.tot_other1,
                    tot_other2_daily = nTot_Other2PreviousDay - c2.tot_other2,
                    bw_a3_daily = nBW_A3PreviousDay - c2.bw_a3,
                    bw_b4_daily = nBW_B4PreviousDay - c2.bw_b4,
                    bw_a4_daily = nBW_A4PreviousDay - c2.bw_a4,
                    bw_b5_daily = nBW_B5PreviousDay - c2.bw_b5,
                    bw_a5_daily = nBW_A5PreviousDay - c2.bw_a5,
                    bw_folio_daily = nBW_FolioPreviousDay - c2.bw_folio,
                    bw_ledger_daily = nBW_LedgerPreviousDay - c2.bw_ledger,
                    bw_legal_daily = nBW_LegalPreviousDay - c2.bw_legal,
                    bw_letter_daily = nBW_LetterPreviousDay - c2.bw_letter,
                    bw_statement_daily = nBW_StatementPreviousDay - c2.bw_statement,
                    bw_banner1_daily = nBW_Banner1PreviousDay - c2.bw_banner1,
                    bw_banner2_daily = nBW_Banner2PreviousDay - c2.bw_banner2,
                    bw_other1_daily = nBW_Other1PreviousDay - c2.bw_other1,
                    bw_other2_daily = nBW_Other2PreviousDay - c2.bw_other2,
                    color_a3_daily = nColor_A3PreviousDay - c2.color_a3,
                    color_b4_daily = nColor_B4PreviousDay - c2.color_b4,
                    color_a4_daily = nColor_A4PreviousDay - c2.color_a4,
                    color_b5_daily = nColor_B5PreviousDay - c2.color_b5,
                    color_a5_daily = nColor_A5PreviousDay - c2.color_a5,
                    color_folio_daily = nColor_FolioPreviousDay - c2.color_folio,
                    color_ledger_daily = nColor_LedgerPreviousDay - c2.color_ledger, 
                    color_legal_daily = nColor_LegalPreviousDay - c2.color_legal,
                    color_letter_daily = nColor_LetterPreviousDay - c2.color_letter,
                    color_statement_daily = nColor_StatementPreviousDay - c2.color_statement,
                    color_banner1_daily = nColor_Banner1PreviousDay - c2.color_banner1,
                    color_banner2_daily = nColor_Banner2PreviousDay - c2.color_banner2,
                    color_other1_daily = nColor_Other1PreviousDay - c2.color_other1,
                    color_other2_daily = nColor_Other2PreviousDay - c2.color_other2 
                Where manual_entry_id = c2.manual_entry_id;
          Exception
              When No_Data_Found Then   
                  Begin
                      Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                        Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                        Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                        Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                        Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                        Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                        Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                        nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                        nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                        nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                        nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                        nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                        From Ss_Pagecount_kyocer 
                        Where prn_queue = Trim(c2.prn_queue)
                        And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where prn_queue = Trim(c2.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                        And prn_online = 1;

                      Update ss_pagecount_kyocer_manual
                        Set tot_a3_daily = c2.tot_a3 - nTot_A3PreviousDay,
                        tot_b4_daily = c2.tot_b4 - nTot_B4PreviousDay,
                        tot_a4_daily = c2.tot_a4 - nTot_A4PreviousDay,
                        tot_b5_daily = c2.tot_b5 - nTot_B5PreviousDay,
                        tot_a5_daily = c2.tot_a5 - nTot_A5PreviousDay,
                        tot_folio_daily = c2.tot_folio - nTot_FolioPreviousDay,
                        tot_ledger_daily = c2.tot_ledger - nTot_LedgerPreviousDay,
                        tot_legal_daily = c2.tot_legal - nTot_LegalPreviousDay,
                        tot_letter_daily = c2.tot_letter - nTot_LetterPreviousDay,
                        tot_statement_daily = c2.tot_statement - nTot_StatementPreviousDay,
                        tot_banner1_daily = c2.tot_banner1 - nTot_Banner1PreviousDay,
                        tot_banner2_daily = c2.tot_banner2 - nTot_Banner2PreviousDay,
                        tot_other1_daily = c2.tot_other1 - nTot_Other1PreviousDay,
                        tot_other2_daily = c2.tot_other2 - nTot_Other2PreviousDay,
                        bw_a3_daily = c2.bw_a3 - nBW_A3PreviousDay,
                        bw_b4_daily = c2.bw_b4 - nBW_B4PreviousDay,
                        bw_a4_daily = c2.bw_a4 - nBW_A4PreviousDay,
                        bw_b5_daily = c2.bw_b5 - nBW_B5PreviousDay,
                        bw_a5_daily = c2.bw_a5 - nBW_A5PreviousDay,
                        bw_folio_daily = c2.bw_folio - nBW_FolioPreviousDay,
                        bw_ledger_daily = c2.bw_ledger - nBW_LedgerPreviousDay,
                        bw_legal_daily = c2.bw_legal - nBW_LegalPreviousDay,
                        bw_letter_daily = c2.bw_letter - nBW_LetterPreviousDay,
                        bw_statement_daily = c2.bw_statement - nBW_StatementPreviousDay,
                        bw_banner1_daily = c2.bw_banner1 - nBW_Banner1PreviousDay,
                        bw_banner2_daily = c2.bw_banner2 - nBW_Banner2PreviousDay,
                        bw_other1_daily = c2.bw_other1 - nBW_Other1PreviousDay,
                        bw_other2_daily = c2.bw_other2 - nBW_Other2PreviousDay,
                        color_a3_daily = c2.color_a3 - nColor_A3PreviousDay,
                        color_b4_daily = c2.color_b4 - nColor_B4PreviousDay,
                        color_a4_daily = c2.color_a4 - nColor_A4PreviousDay,
                        color_b5_daily = c2.color_b5 - nColor_B5PreviousDay,
                        color_a5_daily = c2.color_a5 - nColor_A5PreviousDay,
                        color_folio_daily = c2.color_folio - nColor_FolioPreviousDay,
                        color_ledger_daily = c2.color_ledger - nColor_LedgerPreviousDay,
                        color_legal_daily = c2.color_legal - nColor_LegalPreviousDay,
                        color_letter_daily = c2.color_letter - nColor_LetterPreviousDay,
                        color_statement_daily = c2.color_statement - nColor_StatementPreviousDay,
                        color_banner1_daily = c2.color_banner1 - nColor_Banner1PreviousDay,
                        color_banner2_daily = c2.color_banner2 - nColor_Banner2PreviousDay,
                        color_other1_daily = c2.color_other1 - nColor_Other1PreviousDay,
                        color_other2_daily = c2.color_other2 - nColor_Other2PreviousDay
                    Where Current Of cur_kyocera_manual;
                Exception
                    When No_Data_Found Then
                        Null;
                End;
            End; 
        End Loop;

        For c3 In cur_kyocera_srno Loop        
            Begin
                Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                    Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                    Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                    Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                    Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                    Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                    Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                    nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                    nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                    nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                    nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                    nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                    From Ss_Pagecount_kyocer 
                    Where srno = Trim(c3.srno)
                    And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where srno = Trim(c3.srno) And entry_Date < pEntryDate And prn_online = 1)
                    And prn_online = 1;

                Update ss_pagecount_kyocer
                Set tot_a3_daily_srno = makeZero(c3.tot_a3 - nTot_A3PreviousDay),
                    tot_b4_daily_srno = makeZero(c3.tot_b4 - nTot_B4PreviousDay),
                    tot_a4_daily_srno = makeZero(c3.tot_a4 - nTot_A4PreviousDay),
                    tot_b5_daily_srno = makeZero(c3.tot_b5 - nTot_B5PreviousDay),
                    tot_a5_daily_srno = makeZero(c3.tot_a5 - nTot_A5PreviousDay),
                    tot_folio_daily_srno = makeZero(c3.tot_folio - nTot_FolioPreviousDay),
                    tot_ledger_daily_srno = makeZero(c3.tot_ledger - nTot_LedgerPreviousDay),
                    tot_legal_daily_srno = makeZero(c3.tot_legal - nTot_LegalPreviousDay),
                    tot_letter_daily_srno = makeZero(c3.tot_letter - nTot_LetterPreviousDay),
                    tot_statement_daily_srno = makeZero(c3.tot_statement - nTot_StatementPreviousDay),
                    tot_banner1_daily_srno = makeZero(c3.tot_banner1 - nTot_Banner1PreviousDay),
                    tot_banner2_daily_srno = makeZero(c3.tot_banner2 - nTot_Banner2PreviousDay),
                    tot_other1_daily_srno = makeZero(c3.tot_other1 - nTot_Other1PreviousDay),
                    tot_other2_daily_srno = makeZero(c3.tot_other2 - nTot_Other2PreviousDay),
                    bw_a3_daily_srno = makeZero(c3.bw_a3 - nBW_A3PreviousDay),
                    bw_b4_daily_srno = makeZero(c3.bw_b4 - nBW_B4PreviousDay),
                    bw_a4_daily_srno = makeZero(c3.bw_a4 - nBW_A4PreviousDay),
                    bw_b5_daily_srno = makeZero(c3.bw_b5 - nBW_B5PreviousDay),
                    bw_a5_daily_srno = makeZero(c3.bw_a5 - nBW_A5PreviousDay),
                    bw_folio_daily_srno = makeZero(c3.bw_folio - nBW_FolioPreviousDay),
                    bw_ledger_daily_srno = makeZero(c3.bw_ledger - nBW_LedgerPreviousDay),
                    bw_legal_daily_srno = makeZero(c3.bw_legal - nBW_LegalPreviousDay),
                    bw_letter_daily_srno = makeZero(c3.bw_letter - nBW_LetterPreviousDay),
                    bw_statement_daily_srno = makeZero(c3.bw_statement - nBW_StatementPreviousDay),
                    bw_banner1_daily_srno = makeZero(c3.bw_banner1 - nBW_Banner1PreviousDay),
                    bw_banner2_daily_srno = makeZero(c3.bw_banner2 - nBW_Banner2PreviousDay),
                    bw_other1_daily_srno = makeZero(c3.bw_other1 - nBW_Other1PreviousDay),
                    bw_other2_daily_srno = makeZero(c3.bw_other2 - nBW_Other2PreviousDay),
                    color_a3_daily_srno = makeZero(c3.color_a3 - nColor_A3PreviousDay),
                    color_b4_daily_srno = makeZero(c3.color_b4 - nColor_B4PreviousDay),
                    color_a4_daily_srno = makeZero(c3.color_a4 - nColor_A4PreviousDay),
                    color_b5_daily_srno = makeZero(c3.color_b5 - nColor_B5PreviousDay),
                    color_a5_daily_srno = makeZero(c3.color_a5 - nColor_A5PreviousDay),
                    color_folio_daily_srno = makeZero(c3.color_folio - nColor_FolioPreviousDay),
                    color_ledger_daily_srno = makeZero(c3.color_ledger - nColor_LedgerPreviousDay),
                    color_legal_daily_srno = makeZero(c3.color_legal - nColor_LegalPreviousDay),
                    color_letter_daily_srno = makeZero(c3.color_letter - nColor_LetterPreviousDay),
                    color_statement_daily_srno = makeZero(c3.color_statement - nColor_StatementPreviousDay),
                    color_banner1_daily_srno = makeZero(c3.color_banner1 - nColor_Banner1PreviousDay),
                    color_banner2_daily_srno = makeZero(c3.color_banner2 - nColor_Banner2PreviousDay),
                    color_other1_daily_srno = makeZero(c3.color_other1 - nColor_Other1PreviousDay),
                    color_other2_daily_srno = makeZero(c3.color_other2 - nColor_Other2PreviousDay)
                Where Current Of cur_kyocera_srno;
          Exception
              When No_Data_Found Then
                  Begin
                      Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                          Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                          Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                          Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                          Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                          Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                          Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                          nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                          nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                          nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                          nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                          nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                          From Ss_Pagecount_kyocer_manual
                          Where srno = Trim(c3.srno)
                          And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where srno = Trim(c3.srno) And entry_Date < pEntryDate And prn_online = 1);

                      Update ss_pagecount_kyocer
                      Set tot_a3_daily_srno = c3.tot_a3 - nTot_A3PreviousDay,
                          tot_b4_daily_srno = c3.tot_b4 - nTot_B4PreviousDay,
                          tot_a4_daily_srno = c3.tot_a4 - nTot_A4PreviousDay,
                          tot_b5_daily_srno = c3.tot_b5 - nTot_B5PreviousDay,
                          tot_a5_daily_srno = c3.tot_a5 - nTot_A5PreviousDay,
                          tot_folio_daily_srno = c3.tot_folio - nTot_FolioPreviousDay,
                          tot_ledger_daily_srno = c3.tot_ledger - nTot_LedgerPreviousDay,
                          tot_legal_daily_srno = c3.tot_legal - nTot_LegalPreviousDay,
                          tot_letter_daily_srno = c3.tot_letter - nTot_LetterPreviousDay,
                          tot_statement_daily_srno = c3.tot_statement - nTot_StatementPreviousDay,
                          tot_banner1_daily_srno = c3.tot_banner1 - nTot_Banner1PreviousDay,
                          tot_banner2_daily_srno = c3.tot_banner2 - nTot_Banner2PreviousDay,
                          tot_other1_daily_srno = c3.tot_other1 - nTot_Other1PreviousDay,
                          tot_other2_daily_srno = c3.tot_other2 - nTot_Other2PreviousDay,
                          bw_a3_daily_srno = c3.bw_a3 - nBW_A3PreviousDay,
                          bw_b4_daily_srno = c3.bw_b4 - nBW_B4PreviousDay,
                          bw_a4_daily_srno = c3.bw_a4 - nBW_A4PreviousDay,
                          bw_b5_daily_srno = c3.bw_b5 - nBW_B5PreviousDay,
                          bw_a5_daily_srno = c3.bw_a5 - nBW_A5PreviousDay,
                          bw_folio_daily_srno = c3.bw_folio - nBW_FolioPreviousDay,
                          bw_ledger_daily_srno = c3.bw_ledger - nBW_LedgerPreviousDay,
                          bw_legal_daily_srno = c3.bw_legal - nBW_LegalPreviousDay,
                          bw_letter_daily_srno = c3.bw_letter - nBW_LetterPreviousDay,
                          bw_statement_daily_srno = c3.bw_statement - nBW_StatementPreviousDay,
                          bw_banner1_daily_srno = c3.bw_banner1 - nBW_Banner1PreviousDay,
                          bw_banner2_daily_srno = c3.bw_banner2 - nBW_Banner2PreviousDay,
                          bw_other1_daily_srno = c3.bw_other1 - nBW_Other1PreviousDay,
                          bw_other2_daily_srno = c3.bw_other2 - nBW_Other2PreviousDay,
                          color_a3_daily_srno = c3.color_a3 - nColor_A3PreviousDay,
                          color_b4_daily_srno = c3.color_b4 - nColor_B4PreviousDay,
                          color_a4_daily_srno = c3.color_a4 - nColor_A4PreviousDay,
                          color_b5_daily_srno = c3.color_b5 - nColor_B5PreviousDay,
                          color_a5_daily_srno = c3.color_a5 - nColor_A5PreviousDay,
                          color_folio_daily_srno = c3.color_folio - nColor_FolioPreviousDay,
                          color_ledger_daily_srno = c3.color_ledger - nColor_LedgerPreviousDay,
                          color_legal_daily_srno = c3.color_legal - nColor_LegalPreviousDay,
                          color_letter_daily_srno = c3.color_letter - nColor_LetterPreviousDay,
                          color_statement_daily_srno = c3.color_statement - nColor_StatementPreviousDay,
                          color_banner1_daily_srno = c3.color_banner1 - nColor_Banner1PreviousDay,
                          color_banner2_daily_srno = c3.color_banner2 - nColor_Banner2PreviousDay,
                          color_other1_daily_srno = c3.color_other1 - nColor_Other1PreviousDay,
                          color_other2_daily_srno = c3.color_other2 - nColor_Other2PreviousDay 
                      Where Current Of cur_kyocera_srno;
                  Exception
                      When No_Data_Found Then
                          Null;
                  End;
            End; 
        End Loop;

        For c4 In cur_kyocera_manual_srno Loop        
            Begin
                Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                    Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                    Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                    Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                    Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                    Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                    Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                    nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                    nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                    nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                    nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                    nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                    From Ss_Pagecount_kyocer 
                    Where manual_entry_id = c4.manual_entry_id                    
                    And prn_online = 1;

                Update ss_pagecount_kyocer
                Set tot_a3_daily_srno = nTot_A3PreviousDay - c4.tot_a3,
                    tot_b4_daily_srno = nTot_B4PreviousDay - c4.tot_b4,
                    tot_a4_daily_srno = nTot_A4PreviousDay - c4.tot_a4,
                    tot_b5_daily_srno = nTot_B5PreviousDay - c4.tot_b5,
                    tot_a5_daily_srno = nTot_A5PreviousDay - c4.tot_a5,
                    tot_folio_daily_srno = nTot_FolioPreviousDay - c4.tot_folio,
                    tot_ledger_daily_srno = nTot_LedgerPreviousDay - c4.tot_ledger,
                    tot_legal_daily_srno = nTot_LegalPreviousDay - c4.tot_legal,
                    tot_letter_daily_srno = nTot_LetterPreviousDay - c4.tot_letter,
                    tot_statement_daily_srno = nTot_StatementPreviousDay - c4.tot_statement,
                    tot_banner1_daily_srno = nTot_Banner1PreviousDay - c4.tot_banner1,
                    tot_banner2_daily_srno = nTot_Banner2PreviousDay - c4.tot_banner2,
                    tot_other1_daily_srno = nTot_Other1PreviousDay - c4.tot_other1,
                    tot_other2_daily_srno = nTot_Other2PreviousDay - c4.tot_other2,
                    bw_a3_daily_srno = nBW_A3PreviousDay - c4.bw_a3,
                    bw_b4_daily_srno = nBW_B4PreviousDay - c4.bw_b4,
                    bw_a4_daily_srno = nBW_A4PreviousDay - c4.bw_a4,
                    bw_b5_daily_srno = nBW_B5PreviousDay - c4.bw_b5,
                    bw_a5_daily_srno = nBW_A5PreviousDay - c4.bw_a5,
                    bw_folio_daily_srno = nBW_FolioPreviousDay - c4.bw_folio,
                    bw_ledger_daily_srno = nBW_LedgerPreviousDay - c4.bw_ledger,
                    bw_legal_daily_srno = nBW_LegalPreviousDay - c4.bw_legal,
                    bw_letter_daily_srno = nBW_LetterPreviousDay - c4.bw_letter,
                    bw_statement_daily_srno = nBW_StatementPreviousDay - c4.bw_statement,
                    bw_banner1_daily_srno = nBW_Banner1PreviousDay - c4.bw_banner1,
                    bw_banner2_daily_srno = nBW_Banner2PreviousDay - c4.bw_banner2,
                    bw_other1_daily_srno = nBW_Other1PreviousDay - c4.bw_other1,
                    bw_other2_daily_srno = nBW_Other2PreviousDay - c4.bw_other2,
                    color_a3_daily_srno = nColor_A3PreviousDay - c4.color_a3,
                    color_b4_daily_srno = nColor_B4PreviousDay - c4.color_b4,
                    color_a4_daily_srno = nColor_A4PreviousDay - c4.color_a4,
                    color_b5_daily_srno = nColor_B5PreviousDay - c4.color_b5,
                    color_a5_daily_srno = nColor_A5PreviousDay - c4.color_a5,
                    color_folio_daily_srno = nColor_FolioPreviousDay - c4.color_folio,
                    color_ledger_daily_srno = nColor_LedgerPreviousDay - c4.color_ledger, 
                    color_legal_daily_srno = nColor_LegalPreviousDay - c4.color_legal,
                    color_letter_daily_srno = nColor_LetterPreviousDay - c4.color_letter,
                    color_statement_daily_srno = nColor_StatementPreviousDay - c4.color_statement,
                    color_banner1_daily_srno = nColor_Banner1PreviousDay - c4.color_banner1,
                    color_banner2_daily_srno = nColor_Banner2PreviousDay - c4.color_banner2,
                    color_other1_daily_srno = nColor_Other1PreviousDay - c4.color_other1,
                    color_other2_daily_srno = nColor_Other2PreviousDay - c4.color_other2 
                Where manual_entry_id = c4.manual_entry_id;
          Exception
              When No_Data_Found Then   
                  Begin
                      Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                        Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                        Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                        Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                        Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                        Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                        Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                        nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                        nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                        nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                        nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                        nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                        From Ss_Pagecount_kyocer 
                        Where srno = Trim(c4.srno)
                        And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where srno = Trim(c4.srno) And entry_Date < pEntryDate And prn_online = 1)
                        And prn_online = 1;

                      Update ss_pagecount_kyocer_manual
                        Set tot_a3_daily_srno = c4.tot_a3 - nTot_A3PreviousDay,
                        tot_b4_daily_srno = c4.tot_b4 - nTot_B4PreviousDay,
                        tot_a4_daily_srno = c4.tot_a4 - nTot_A4PreviousDay,
                        tot_b5_daily_srno = c4.tot_b5 - nTot_B5PreviousDay,
                        tot_a5_daily_srno = c4.tot_a5 - nTot_A5PreviousDay,
                        tot_folio_daily_srno = c4.tot_folio - nTot_FolioPreviousDay,
                        tot_ledger_daily_srno = c4.tot_ledger - nTot_LedgerPreviousDay,
                        tot_legal_daily_srno = c4.tot_legal - nTot_LegalPreviousDay,
                        tot_letter_daily_srno = c4.tot_letter - nTot_LetterPreviousDay,
                        tot_statement_daily_srno = c4.tot_statement - nTot_StatementPreviousDay,
                        tot_banner1_daily_srno = c4.tot_banner1 - nTot_Banner1PreviousDay,
                        tot_banner2_daily_srno = c4.tot_banner2 - nTot_Banner2PreviousDay,
                        tot_other1_daily_srno = c4.tot_other1 - nTot_Other1PreviousDay,
                        tot_other2_daily_srno = c4.tot_other2 - nTot_Other2PreviousDay,
                        bw_a3_daily_srno = c4.bw_a3 - nBW_A3PreviousDay,
                        bw_b4_daily_srno = c4.bw_b4 - nBW_B4PreviousDay,
                        bw_a4_daily_srno = c4.bw_a4 - nBW_A4PreviousDay,
                        bw_b5_daily_srno = c4.bw_b5 - nBW_B5PreviousDay,
                        bw_a5_daily_srno = c4.bw_a5 - nBW_A5PreviousDay,
                        bw_folio_daily_srno = c4.bw_folio - nBW_FolioPreviousDay,
                        bw_ledger_daily_srno = c4.bw_ledger - nBW_LedgerPreviousDay,
                        bw_legal_daily_srno = c4.bw_legal - nBW_LegalPreviousDay,
                        bw_letter_daily_srno = c4.bw_letter - nBW_LetterPreviousDay,
                        bw_statement_daily_srno = c4.bw_statement - nBW_StatementPreviousDay,
                        bw_banner1_daily_srno = c4.bw_banner1 - nBW_Banner1PreviousDay,
                        bw_banner2_daily_srno = c4.bw_banner2 - nBW_Banner2PreviousDay,
                        bw_other1_daily_srno = c4.bw_other1 - nBW_Other1PreviousDay,
                        bw_other2_daily_srno = c4.bw_other2 - nBW_Other2PreviousDay,
                        color_a3_daily_srno = c4.color_a3 - nColor_A3PreviousDay,
                        color_b4_daily_srno = c4.color_b4 - nColor_B4PreviousDay,
                        color_a4_daily_srno = c4.color_a4 - nColor_A4PreviousDay,
                        color_b5_daily_srno = c4.color_b5 - nColor_B5PreviousDay,
                        color_a5_daily_srno = c4.color_a5 - nColor_A5PreviousDay,
                        color_folio_daily_srno = c4.color_folio - nColor_FolioPreviousDay,
                        color_ledger_daily_srno = c4.color_ledger - nColor_LedgerPreviousDay,
                        color_legal_daily_srno = c4.color_legal - nColor_LegalPreviousDay,
                        color_letter_daily_srno = c4.color_letter - nColor_LetterPreviousDay,
                        color_statement_daily_srno = c4.color_statement - nColor_StatementPreviousDay,
                        color_banner1_daily_srno = c4.color_banner1 - nColor_Banner1PreviousDay,
                        color_banner2_daily_srno = c4.color_banner2 - nColor_Banner2PreviousDay,
                        color_other1_daily_srno = c4.color_other1 - nColor_Other1PreviousDay,
                        color_other2_daily_srno = c4.color_other2 - nColor_Other2PreviousDay
                    Where Current Of cur_kyocera_manual_srno;
                Exception
                    When No_Data_Found Then
                        Null;
                End;
            End; 
        End Loop;                         
        Commit;
    End;

    Function insertUpdateCanonManual(metroEntryDate varchar2, metroManualEntryID Varchar2, metroIPAddress Varchar2, metroPrinterQueue Varchar2, metroSrNo Varchar2, metroHostName Varchar2,
                                     metroPrinterName Varchar2, metroOffice Varchar2, metroFloor Varchar2, metroWing Varchar2,
                                     mTxtBlackLarge integer, mTxtBlackSmall integer, mTxtColorLarge integer, mTxtColorSmall integer, mTxtTotal2Sided integer, mTxtTotal integer, mTxtTotal2 integer) Return Number Is
        nEntryDate number;                
        nManualEntryID Number(10);
    Begin        
        Select Count(entry_date) Into nEntryDate From ss_pagecount_canon_manual Where manual_entry_id = To_Number(metroManualEntryID);

        If nEntryDate = 0 Then
            Select network_printer_data_seq.nextval Into nManualEntryID From dual;

            Insert into ss_pagecount_canon_manual
                Values( metroEntryDate,
                        Trim(metroIPAddress), 
                        Trim(metroPrinterQueue), 
                        Trim(metroSrNo), 
                        Trim(metroHostName), 
                        Trim(metroPrinterName), 
                        1, 
                        Trim(metroOffice), 
                        Trim(metroFloor), 
                        Trim(metroWing),
                        Nvl(mTxtTotal,0), 
                        Nvl(mTxtBlackLarge,0), 
                        Nvl(mTxtBlackSmall,0), 
                        Nvl(mTxtColorLarge,0), 
                        Nvl(mTxtColorSmall,0),
                        Nvl(mTxtTotal2Sided,0), 
                        Nvl(mTxtTotal2,0), 
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        nManualEntryID,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0);

             Update ss_pagecount_canon
                Set manual_entry_id = nManualEntryID
                Where prn_queue = Trim(metroPrinterQueue)
                And entry_date = Trim(metroEntryDate);            
        Else
            Update ss_pagecount_canon_manual
                Set blacklarge = Nvl(mTxtBlackLarge,0),
                    blacksmall = Nvl(mTxtBlackSmall,0), 
                    colorlarge = Nvl(mTxtColorLarge,0), 
                    colorsmall = Nvl(mTxtColorSmall,0),
                    total = Nvl(mTxtTotal,0), 
                    total2sided = Nvl(mTxtTotal2Sided,0),
                    total2 = Nvl(mTxtTotal2,0)
                Where manual_entry_id = To_Number(metroManualEntryID);            
        End If;
        getCanonDataPrinterQueue(metroEntryDate, metroPrinterQueue);        
        Commit;
        Return 1;
    Exception 
        When Others Then
            Return -1;
    End;

    Function insertUpdateKyoceraManual(metroEntryDate Varchar2, metroManualEntryID Varchar2, metroIPAddress Varchar2, metroPrinterQueue Varchar2, metroSrNo Varchar2, metroHostName Varchar2,
                                        metroPrinterName Varchar2, metroOffice Varchar2, metroFloor Varchar2, metroWing Varchar2,
                                        mTxtBWA3 Integer, mTxtBWB4 Integer, mTxtBWA4 Integer, mTxtBWB5 Integer, mTxtBWA5 Integer, mTxtBWFolio Integer, mTxtBWLedger Integer, mTxtBWLegal Integer,
                                        mTxtBWLetter Integer, mTxtBWStatement Integer, mTxtBWBanner1 Integer, mTxtBWBanner2 Integer, mTxtBWOther1 Integer, mTxtBWOther2 Integer, mTxtColorA3 Integer,
                                        mTxtColorB4 Integer, mTxtColorA4 Integer, mTxtColorB5 Integer, mTxtColorA5 Integer, mTxtColorFolio Integer, mTxtColorLedger Integer, mTxtColorLegal Integer,
                                        mTxtColorLetter Integer, mTxtColorStatement Integer, mTxtColorBanner1 Integer, mTxtColorBanner2 Integer, mTxtColorOther1 Integer, mTxtColorOther2 Integer, mTxtTotalA3 Integer,
                                        mTxtTotalB4 Integer, mTxtTotalA4 Integer, mTxtTotalB5 Integer, mTxtTotalA5 Integer, mTxtTotalFolio Integer, mTxtTotalLedger Integer, mTxtTotalLegal Integer,
                                        mTxtTotalLetter Integer, mTxtTotalStatement Integer, mTxtTotalBanner1 Integer, mTxtTotalBanner2 Integer, mTxtTotalOther1 Integer, mTxtTotalOther2 Integer) Return Number Is
        nEntryDate number;                
        nManualEntryID Number(10);
    Begin        
        Select Count(entry_date) Into nEntryDate From ss_pagecount_kyocer_manual Where manual_entry_id = To_Number(metroManualEntryID);

        If nEntryDate = 0 Then
            Select network_printer_data_seq.nextval Into nManualEntryID From dual;

            Insert into ss_pagecount_kyocer_manual
                Values( metroEntryDate,
                        Trim(metroIPAddress), 
                        Trim(metroPrinterQueue), 
                        Trim(metroSrNo), 
                        Trim(metroHostName), 
                        Trim(metroPrinterName), 
                        1, 
                        Trim(metroOffice), 
                        Trim(metroFloor), 
                        Trim(metroWing),
                        Nvl(mTxtTotalA3,0), 
                        Nvl(mTxtTotalB4,0), 
                        Nvl(mTxtTotalA4,0), 
                        Nvl(mTxtTotalB5,0), 
                        Nvl(mTxtTotalA5,0), 
                        Nvl(mTxtTotalFolio,0), 
                        Nvl(mTxtTotalLedger,0), 
                        Nvl(mTxtTotalLegal,0), 
                        Nvl(mTxtTotalLetter,0), 
                        Nvl(mTxtTotalStatement,0), 
                        Nvl(mTxtTotalBanner1,0), 
                        Nvl(mTxtTotalBanner2,0), 
                        Nvl(mTxtTotalOther1,0), 
                        Nvl(mTxtTotalOther2,0), 
                        Nvl(mTxtBWA3,0), 
                        Nvl(mTxtBWB4,0), 
                        Nvl(mTxtBWA4,0), 
                        Nvl(mTxtBWB5,0), 
                        Nvl(mTxtBWA5,0), 
                        Nvl(mTxtBWFolio,0), 
                        Nvl(mTxtBWLedger,0), 
                        Nvl(mTxtBWLegal,0), 
                        Nvl(mTxtBWLetter,0), 
                        Nvl(mTxtBWStatement,0), 
                        Nvl(mTxtBWBanner1,0), 
                        Nvl(mTxtBWBanner2,0), 
                        Nvl(mTxtBWOther1,0), 
                        Nvl(mTxtBWOther2,0), 
                        Nvl(mTxtColorA3,0), 
                        Nvl(mTxtColorB4,0), 
                        Nvl(mTxtColorA4,0), 
                        Nvl(mTxtColorB5,0), 
                        Nvl(mTxtColorA5,0), 
                        Nvl(mTxtColorFolio,0), 
                        Nvl(mTxtColorLedger,0), 
                        Nvl(mTxtColorLegal,0), 
                        Nvl(mTxtColorLetter,0), 
                        Nvl(mTxtColorStatement,0), 
                        Nvl(mTxtColorBanner1,0), 
                        Nvl(mTxtColorBanner2,0), 
                        Nvl(mTxtColorOther1,0), 
                        Nvl(mTxtColorOther2,0), 
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        nManualEntryID,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0);

             Update ss_pagecount_kyocer
                Set manual_entry_id = nManualEntryID
                Where prn_queue = Trim(metroPrinterQueue)
                And entry_date = Trim(metroEntryDate);            
        Else
            Update ss_pagecount_kyocer_manual
                Set tot_a3 = Nvl(mTxtTotalA3,0),
                    tot_b4 = Nvl(mTxtTotalB4,0),
                    tot_a4 = Nvl(mTxtTotalA4,0),
                    tot_b5 = Nvl(mTxtTotalB5,0),
                    tot_a5 = Nvl(mTxtTotalA5,0),
                    tot_folio = Nvl(mTxtTotalFolio,0),
                    tot_ledger = Nvl(mTxtTotalLedger,0),
                    tot_legal = Nvl(mTxtTotalLegal,0),
                    tot_letter = Nvl(mTxtTotalLetter,0),
                    tot_statement = Nvl(mTxtTotalStatement,0),
                    tot_banner1 = Nvl(mTxtTotalBanner1,0),
                    tot_banner2 = Nvl(mTxtTotalBanner2,0),
                    tot_other1 = Nvl(mTxtTotalOther1,0),
                    tot_other2 = Nvl(mTxtTotalOther2,0),
                    bw_a3 = Nvl(mTxtBWA3,0),
                    bw_b4 = Nvl(mTxtBWB4,0),
                    bw_a4 = Nvl(mTxtBWA4,0),
                    bw_b5 = Nvl(mTxtBWB5,0),
                    bw_a5 = Nvl(mTxtBWA5,0),
                    bw_folio = Nvl(mTxtBWFolio,0),
                    bw_ledger = Nvl(mTxtBWLedger,0),
                    bw_legal = Nvl(mTxtBWLegal,0),
                    bw_letter = Nvl(mTxtBWLetter,0),
                    bw_statement = Nvl(mTxtBWStatement,0),
                    bw_banner1 = Nvl(mTxtBWBanner1,0),
                    bw_banner2 = Nvl(mTxtBWBanner2,0),
                    bw_other1 = Nvl(mTxtBWOther1,0),
                    bw_other2 = Nvl(mTxtBWOther2,0),
                    color_a3 = Nvl(mTxtColorA3,0),
                    color_b4 = Nvl(mTxtColorB4,0),
                    color_a4 = Nvl(mTxtColorA4,0),
                    color_b5 = Nvl(mTxtColorB5,0),
                    color_a5 = Nvl(mTxtColorA5,0),
                    color_folio = Nvl(mTxtColorFolio,0),
                    color_ledger = Nvl(mTxtColorLedger,0),
                    color_legal = Nvl(mTxtColorLegal,0),
                    color_letter = Nvl(mTxtColorLetter,0),
                    color_statement = Nvl(mTxtColorStatement,0),
                    color_banner1 = Nvl(mTxtColorBanner1,0),
                    color_banner2 = Nvl(mTxtColorBanner2,0),
                    color_other1 = Nvl(mTxtColorOther1,0),
                    color_other2 = Nvl(mTxtColorOther2,0)
                Where manual_entry_id = To_Number(metroManualEntryID);            
        End If;
        getKyoceraDataPrinterQueue(metroEntryDate, metroPrinterQueue);        
        Commit;
        Return 1;
    Exception 
        When Others Then
            Return -1;
    End;

    Function deleteCanonManual(metroManualEntryID Varchar2) Return Number Is
    Begin
        Delete From ss_pagecount_canon_manual Where manual_entry_id = To_Number(metroManualEntryID);
        Update ss_pagecount_canon 
        Set manual_entry_id = Null,
            total_daily = Null,
            blacklarge_daily = Null,
            blacksmall_daily = Null,
            colorlarge_daily = Null,
            colorsmall_daily = Null,
            total2sided_daily = Null,
            total2_daily = Null,
            total_daily_srno = Null,
            blacklarge_daily_srno = Null,
            blacksmall_daily_srno = Null,
            colorlarge_daily_srno = Null,
            colorsmall_daily_srno = Null,
            total2sided_daily_srno = Null,
            total2_daily_srno = Null
        Where manual_entry_id = To_Number(metroManualEntryID);
        Commit;
        Return 1;
    Exception
        When Others Then
            Return -1;
    End;

    Function deleteKyoceraManual(metroManualEntryID Varchar2) Return Number Is
    Begin
        Delete From ss_pagecount_kyocer_manual Where manual_entry_id = To_Number(metroManualEntryID);
        Update ss_pagecount_kyocer 
        Set manual_entry_id = Null,        
            tot_a3_daily = Null,
            tot_b4_daily = Null,
            tot_a4_daily = Null,
            tot_b5_daily = Null,
            tot_a5_daily = Null,
            tot_folio_daily = Null,
            tot_ledger_daily = Null,
            tot_legal_daily = Null,
            tot_letter_daily = Null,
            tot_statement_daily = Null,
            tot_banner1_daily = Null,
            tot_banner2_daily = Null,
            tot_other1_daily = Null,
            tot_other2_daily = Null,
            bw_a3_daily = Null,
            bw_b4_daily = Null,
            bw_a4_daily = Null,
            bw_b5_daily = Null,
            bw_a5_daily = Null,
            bw_folio_daily = Null,
            bw_ledger_daily = Null,
            bw_legal_daily = Null,
            bw_letter_daily = Null,
            bw_statement_daily = Null,
            bw_banner1_daily = Null,
            bw_banner2_daily = Null,
            bw_other1_daily = Null,
            bw_other2_daily = Null,
            color_a3_daily = Null,
            color_b4_daily = Null,
            color_a4_daily = Null,
            color_b5_daily = Null,
            color_a5_daily = Null,
            color_folio_daily = Null,
            color_ledger_daily = Null,
            color_legal_daily = Null,
            color_letter_daily = Null,
            color_statement_daily = Null,
            color_banner1_daily = Null,
            color_banner2_daily = Null,
            color_other1_daily = Null,
            color_other2_daily = Null,
			tot_a3_daily_srno = Null,
            tot_b4_daily_srno = Null,
            tot_a4_daily_srno = Null,
            tot_b5_daily_srno = Null,
            tot_a5_daily_srno = Null,
            tot_folio_daily_srno = Null,
            tot_ledger_daily_srno = Null,
            tot_legal_daily_srno = Null,
            tot_letter_daily_srno = Null,
            tot_statement_daily_srno = Null,
            tot_banner1_daily_srno = Null,
            tot_banner2_daily_srno = Null,
            tot_other1_daily_srno = Null,
            tot_other2_daily_srno = Null,
            bw_a3_daily_srno = Null,
            bw_b4_daily_srno = Null,
            bw_a4_daily_srno = Null,
            bw_b5_daily_srno = Null,
            bw_a5_daily_srno = Null,
            bw_folio_daily_srno = Null,
            bw_ledger_daily_srno = Null,
            bw_legal_daily_srno = Null,
            bw_letter_daily_srno = Null,
            bw_statement_daily_srno = Null,
            bw_banner1_daily_srno = Null,
            bw_banner2_daily_srno = Null,
            bw_other1_daily_srno = Null,
            bw_other2_daily_srno = Null,
            color_a3_daily_srno = Null,
            color_b4_daily_srno = Null,
            color_a4_daily_srno = Null,
            color_b5_daily_srno = Null,
            color_a5_daily_srno = Null,
            color_folio_daily_srno = Null,
            color_ledger_daily_srno = Null,
            color_legal_daily_srno = Null,
            color_letter_daily_srno = Null,
            color_statement_daily_srno = Null,
            color_banner1_daily_srno = Null,
            color_banner2_daily_srno = Null,
            color_other1_daily_srno = Null,
            color_other2_daily_srno = Null                
        Where manual_entry_id = To_Number(metroManualEntryID);
        Commit;
        Return 1;
    Exception
        When Others Then
            Return -1;
    End;    

    Procedure sendMail(metroEntryDate Varchar2) Is
        vFrom      Varchar2(80) := 'selfservice@tecnimont.in';
        --vRecipient Varchar2(80) := 's.kanakath@tecnimont.in';
        vRecipient Varchar2(80) := 'r.ganbavale@tecnimont.in';
        vCc Varchar2(80) := 's.kanakath@tecnimont.in';
        vSubject   Varchar2(80) := 'Details of Inactive Printers';
        vMailHost Varchar2(30) := 'ticbexhcn1.ticb.comp';
        vMailConn utl_smtp.Connection;        
        vFileContent  Long;
        vPlainText Varchar2(4000);
        lBoundary    varchar2(100) := '****************************************************************************************************';
        Cursor cur_canon Is Select ipaddress, prn_queue, Office, Floor, wing From ss_pagecount_canon Where prn_online = -1 And entry_date = Trim(metroEntryDate) Order By prn_queue;
        Cursor cur_kyocera Is Select ipaddress, prn_queue, Office, Floor, wing From ss_pagecount_kyocer Where prn_online = -1 And entry_date = Trim(metroEntryDate) Order By prn_queue;
    Begin                
        vPlainText := vPlainText || Chr(10) ||'Hello,';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Please find the attached List of Inactive Printers.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Thanks and Regards,';
        vPlainText := vPlainText || Chr(10) || 'Network Printer Data Application.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || lBoundary;
        vPlainText := vPlainText || Chr(10) || 'This is an automatically generated email. Please do not reply to it.';

        vFileContent := 'Canon -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing'; 
        For c1 In cur_canon Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing;
        End Loop;

        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || 'Kyocera -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing'; 
        For c1 In cur_kyocera Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing;
        End Loop;

        vMailConn := UTL_SMTP.Open_Connection(vMailHost, 25);        
        UTL_SMTP.Helo(vMailConn, vMailHost);        
        UTL_SMTP.Mail(vMailConn, vFrom);
        UTL_SMTP.Rcpt(vMailConn, vRecipient);
        UTL_SMTP.Rcpt(vMailConn, vCc);
        UTL_SMTP.Open_Data(vMailConn);
        UTL_SMTP.Write_Data(vMailConn, 'Date: ' || To_Char(Sysdate, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'To: '   || vRecipient || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Cc: '   || vCc || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'From: ' || vFrom || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Subject: '|| vSubject || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: multipart/mixed; boundary="' || lBoundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);           
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, vPlainText || UTL_TCP.crlf || UTL_TCP.crlf);                
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, ' name='||metroEntryDate||'".csv"'  || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Transfer_Encoding: 8bit' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Disposition: attachment;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, 'filename='||metroEntryDate||'".csv"' || UTL_TCP.crlf|| UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, vFileContent || UTL_TCP.crlf || UTL_TCP.crlf);        
        UTL_SMTP.Close_Data(vMailConn);    
        UTL_SMTP.Quit(vMailConn);              
        commit;
    Exception
        When utl_smtp.Transient_Error OR utl_smtp.Permanent_Error Then
            Raise_Application_Error(-20000, 'Unable to send mail', True);            
    End;    

    Function getCanonBWA3(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nBlackLarge ss_pagecount_canon.blacklarge%type;
    Begin
        Select blacklarge Into nBlackLarge From
            (Select a.entry_date, Greatest(Nvl(a.blacklarge, 0), Nvl(b.blacklarge, 0)) blacklarge From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)            
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonBWA4(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nBlackSmall ss_pagecount_canon.BlackSmall%type;
    Begin
        Select BlackSmall Into nBlackSmall From
            (Select a.entry_date, Greatest(Nvl(a.BlackSmall, 0), Nvl(b.BlackSmall, 0)) BlackSmall From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonColorA3(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nColorLarge ss_pagecount_canon.Colorlarge%type;
    Begin
        Select Colorlarge Into nColorLarge From
            (Select a.entry_date, Greatest(Nvl(a.Colorlarge, 0), Nvl(b.Colorlarge, 0)) Colorlarge From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonColorA4(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nColorSmall ss_pagecount_canon.ColorSmall%type;
    Begin
        Select ColorSmall Into nColorSmall From
            (Select a.entry_date, Greatest(Nvl(a.ColorSmall, 0), Nvl(b.ColorSmall, 0)) ColorSmall From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraBWA3(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nBlackLarge ss_pagecount_kyocer.bw_a3%type;
    Begin
        Select bw_a3 Into nBlackLarge From
            (Select a.entry_date, Greatest(Nvl(a.bw_a3, 0), Nvl(b.bw_a3, 0)) bw_a3 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)            
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraBWA4(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nBlackSmall ss_pagecount_kyocer.bw_a4%type;
    Begin
        Select bw_a4 Into nBlackSmall From
            (Select a.entry_date, Greatest(Nvl(a.bw_b4, 0), Nvl(b.bw_b4, 0)) + 
                                  Greatest(Nvl(a.bw_a4, 0), Nvl(b.bw_a4, 0)) + 
                                  Greatest(Nvl(a.bw_b5, 0), Nvl(b.bw_b5, 0)) + 
                                  Greatest(Nvl(a.bw_a5, 0), Nvl(b.bw_a5, 0)) + 
                                  Greatest(Nvl(a.bw_folio, 0), Nvl(b.bw_folio, 0)) + 
                                  Greatest(Nvl(a.bw_ledger, 0), Nvl(b.bw_ledger, 0)) + 
                                  Greatest(Nvl(a.bw_legal, 0), Nvl(b.bw_legal, 0)) + 
                                  Greatest(Nvl(a.bw_letter, 0), Nvl(b.bw_letter, 0)) + 
                                  Greatest(Nvl(a.bw_statement, 0), Nvl(b.bw_statement, 0)) + 
                                  Greatest(Nvl(a.bw_banner1, 0), Nvl(b.bw_banner1, 0)) + 
                                  Greatest(Nvl(a.bw_banner2, 0), Nvl(b.bw_banner2, 0)) + 
                                  Greatest(Nvl(a.bw_other1, 0), Nvl(b.bw_other1, 0)) + 
                                  Greatest(Nvl(a.bw_other2, 0), Nvl(b.bw_other2, 0)) bw_a4 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraColorA3(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nColorLarge ss_pagecount_kyocer.color_a3%type;
    Begin
        Select Color_a3 Into nColorLarge From
            (Select a.entry_date, Greatest(Nvl(a.Color_a3, 0), Nvl(b.Color_a3, 0)) color_a3 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraColorA4(pPrnQueue Varchar2, pToDate Varchar2) Return number Is
        nColorSmall ss_pagecount_kyocer.color_a4%type;
    Begin
        Select Color_a4 Into nColorSmall From
            (Select a.entry_date, Greatest(Nvl(a.color_b4, 0), Nvl(b.color_b4, 0)) + 
                                  Greatest(Nvl(a.color_a4, 0), Nvl(b.color_a4, 0)) + 
                                  Greatest(Nvl(a.color_b5, 0), Nvl(b.color_b5, 0)) + 
                                  Greatest(Nvl(a.color_a5, 0), Nvl(b.color_a5, 0)) + 
                                  Greatest(Nvl(a.color_folio, 0), Nvl(b.color_folio, 0)) + 
                                  Greatest(Nvl(a.color_ledger, 0), Nvl(b.color_ledger, 0)) + 
                                  Greatest(Nvl(a.color_legal, 0), Nvl(b.color_legal, 0)) + 
                                  Greatest(Nvl(a.color_letter, 0), Nvl(b.color_letter, 0)) + 
                                  Greatest(Nvl(a.color_statement, 0), Nvl(b.color_statement, 0)) + 
                                  Greatest(Nvl(a.color_banner1, 0), Nvl(b.color_banner1, 0)) + 
                                  Greatest(Nvl(a.color_banner2, 0), Nvl(b.color_banner2, 0)) + 
                                  Greatest(Nvl(a.color_other1, 0), Nvl(b.color_other1, 0)) + 
                                  Greatest(Nvl(a.color_other2, 0), Nvl(b.color_other2, 0)) color_a4 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b            
            Where a.prn_queue = Trim(pPrnQueue)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;           

    Function getCanonBWA3SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nBlackLarge ss_pagecount_canon.blacklarge%type;
    Begin
        Select blacklarge Into nBlackLarge From
            (Select a.entry_date, Greatest(Nvl(a.blacklarge, 0), Nvl(b.blacklarge, 0)) blacklarge From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)            
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonBWA4SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nBlackSmall ss_pagecount_canon.BlackSmall%type;
    Begin
        Select BlackSmall Into nBlackSmall From
            (Select a.entry_date, Greatest(Nvl(a.BlackSmall, 0), Nvl(b.BlackSmall, 0)) BlackSmall From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonColorA3SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nColorLarge ss_pagecount_canon.Colorlarge%type;
    Begin
        Select Colorlarge Into nColorLarge From
            (Select a.entry_date, Greatest(Nvl(a.Colorlarge, 0), Nvl(b.Colorlarge, 0)) Colorlarge From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getCanonColorA4SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nColorSmall ss_pagecount_canon.ColorSmall%type;
    Begin
        Select ColorSmall Into nColorSmall From
            (Select a.entry_date, Greatest(Nvl(a.ColorSmall, 0), Nvl(b.ColorSmall, 0)) ColorSmall From ss_pagecount_canon a, ss_pagecount_canon_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraBWA3SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nBlackLarge ss_pagecount_kyocer.bw_a3%type;
    Begin
        Select bw_a3 Into nBlackLarge From
            (Select a.entry_date, Greatest(Nvl(a.bw_a3, 0), Nvl(b.bw_a3, 0)) bw_a3 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)            
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraBWA4SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nBlackSmall ss_pagecount_kyocer.bw_a4%type;
    Begin
        Select bw_a4 Into nBlackSmall From
            (Select a.entry_date, Greatest(Nvl(a.bw_b4, 0), Nvl(b.bw_b4, 0)) + 
                                  Greatest(Nvl(a.bw_a4, 0), Nvl(b.bw_a4, 0)) + 
                                  Greatest(Nvl(a.bw_b5, 0), Nvl(b.bw_b5, 0)) + 
                                  Greatest(Nvl(a.bw_a5, 0), Nvl(b.bw_a5, 0)) + 
                                  Greatest(Nvl(a.bw_folio, 0), Nvl(b.bw_folio, 0)) + 
                                  Greatest(Nvl(a.bw_ledger, 0), Nvl(b.bw_ledger, 0)) + 
                                  Greatest(Nvl(a.bw_legal, 0), Nvl(b.bw_legal, 0)) + 
                                  Greatest(Nvl(a.bw_letter, 0), Nvl(b.bw_letter, 0)) + 
                                  Greatest(Nvl(a.bw_statement, 0), Nvl(b.bw_statement, 0)) + 
                                  Greatest(Nvl(a.bw_banner1, 0), Nvl(b.bw_banner1, 0)) + 
                                  Greatest(Nvl(a.bw_banner2, 0), Nvl(b.bw_banner2, 0)) + 
                                  Greatest(Nvl(a.bw_other1, 0), Nvl(b.bw_other1, 0)) + 
                                  Greatest(Nvl(a.bw_other2, 0), Nvl(b.bw_other2, 0)) bw_a4 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nBlackSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraColorA3SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nColorLarge ss_pagecount_kyocer.color_a3%type;
    Begin
        Select Color_a3 Into nColorLarge From
            (Select a.entry_date, Greatest(Nvl(a.Color_a3, 0), Nvl(b.Color_a3, 0)) color_a3 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorLarge;
    Exception
        When No_Data_Found Then
            Return 0;
    End;

    Function getKyoceraColorA4SrNo(pSrNo Varchar2, pToDate Varchar2) Return number Is
        nColorSmall ss_pagecount_kyocer.color_a4%type;
    Begin
        Select Color_a4 Into nColorSmall From
            (Select a.entry_date, Greatest(Nvl(a.color_b4, 0), Nvl(b.color_b4, 0)) + 
                                  Greatest(Nvl(a.color_a4, 0), Nvl(b.color_a4, 0)) + 
                                  Greatest(Nvl(a.color_b5, 0), Nvl(b.color_b5, 0)) + 
                                  Greatest(Nvl(a.color_a5, 0), Nvl(b.color_a5, 0)) + 
                                  Greatest(Nvl(a.color_folio, 0), Nvl(b.color_folio, 0)) + 
                                  Greatest(Nvl(a.color_ledger, 0), Nvl(b.color_ledger, 0)) + 
                                  Greatest(Nvl(a.color_legal, 0), Nvl(b.color_legal, 0)) + 
                                  Greatest(Nvl(a.color_letter, 0), Nvl(b.color_letter, 0)) + 
                                  Greatest(Nvl(a.color_statement, 0), Nvl(b.color_statement, 0)) + 
                                  Greatest(Nvl(a.color_banner1, 0), Nvl(b.color_banner1, 0)) + 
                                  Greatest(Nvl(a.color_banner2, 0), Nvl(b.color_banner2, 0)) + 
                                  Greatest(Nvl(a.color_other1, 0), Nvl(b.color_other1, 0)) + 
                                  Greatest(Nvl(a.color_other2, 0), Nvl(b.color_other2, 0)) color_a4 From ss_pagecount_kyocer a, ss_pagecount_kyocer_manual b            
            Where a.srno = Trim(pSrNo)
            And a.entry_date <= pToDate
            And a.prn_online = 1
            And a.manual_entry_id = b.manual_entry_id(+)
            Order by a.entry_date desc)
        Where rownum = 1;
        Return nColorSmall;
    Exception
        When No_Data_Found Then
            Return 0;
    End;                     

    Procedure getCanonDataPrinterQueue(pEntryDate Varchar2, pPrnQueue Varchar2) Is
        nTotalPreviousDay ss_pagecount_canon.total%type;
        nBlackLargePreviousDay ss_pagecount_canon.blacklarge%type;
        nBlackSmallPreviousDay ss_pagecount_canon.blacksmall%type;
        nColorLargePreviousDay ss_pagecount_canon.colorlarge%type;
        nColorSmallPreviousDay ss_pagecount_canon.colorsmall%type;
        nTotal2SidedPreviousDay ss_pagecount_canon.total2sided%type;
        nTotal2PreviousDay ss_pagecount_canon.total2%type;                      

        Cursor cur_canon_manual Is 
            Select prn_queue, Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2, manual_entry_id, prn_online
            From Ss_Pagecount_Canon_manual
            Where entry_Date = pEntryDate
            And prn_queue = Trim(pPrnQueue) 
            For Update Of total_daily, blacklarge_daily, blacksmall_daily, colorlarge_daily, colorsmall_daily, total2sided_daily, total2_daily;
    Begin        
        For c2 In cur_canon_manual Loop
            Begin
                Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                   Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                    nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                    From ss_pagecount_canon
                    Where manual_entry_id = c2.manual_entry_id
                    And prn_online = 1;     

                Update ss_pagecount_canon
                Set total_daily = nTotalPreviousDay-c2.total,
                    blacklarge_daily = nBlackLargePreviousDay-c2.blacklarge,
                    blacksmall_daily = nBlackSmallPreviousDay-c2.blacksmall,
                    colorlarge_daily = nColorLargePreviousDay-c2.colorlarge,
                    colorsmall_daily = nColorSmallPreviousDay-c2.colorsmall,
                    total2sided_daily = nTotal2SidedPreviousDay-c2.total2sided,
                    total2_daily = nTotal2PreviousDay-c2.total2
                Where manual_entry_id = c2.manual_entry_id;                
            Exception
                When No_Data_Found Then
                    Begin
                        Select Nvl(total, 0) total, Nvl(blacklarge, 0) blacklarge, Nvl(blacksmall, 0) blacksmall, Nvl(colorlarge, 0) colorlarge, Nvl(colorsmall, 0) colorsmall, 
                            Nvl(total2sided, 0) total2sided, Nvl(total2, 0) total2 Into 
                            nTotalPreviousDay, nBlackLargePreviousDay, nBlackSmallPreviousDay, nColorLargePreviousDay, nColorSmallPreviousDay, nTotal2SidedPreviousDay, nTotal2PreviousDay 
                            From ss_pagecount_canon
                            Where prn_queue = Trim(c2.prn_queue)                    
                            And entry_Date = (Select Max(entry_Date) From Ss_Pagecount_Canon Where prn_queue = Trim(c2.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                            And prn_online = 1;

                        Update ss_pagecount_canon_manual
                            Set total_daily = c2.total-nTotalPreviousDay,
                                blacklarge_daily = c2.blacklarge-nBlackLargePreviousDay,
                                blacksmall_daily = c2.blacksmall-nBlackSmallPreviousDay,
                                colorlarge_daily = c2.colorlarge-nColorLargePreviousDay,
                                colorsmall_daily = c2.colorsmall-nColorSmallPreviousDay,
                                total2sided_daily = c2.total2sided-nTotal2SidedPreviousDay,
                                total2_daily = c2.total2-nTotal2PreviousDay
                            Where current of cur_canon_manual;                           
                    Exception
                        When No_Data_Found Then
                            Null;
                    End;
            End;
        End Loop;
        Commit;        
    End;  

    Procedure getKyoceraDataPrinterQueue(pEntryDate Varchar2, pPrnQueue Varchar2) Is
        nTot_A3PreviousDay ss_pagecount_kyocer.Tot_A3%type;
        nTot_B4PreviousDay ss_pagecount_kyocer.Tot_B4%type;
        nTot_A4PreviousDay ss_pagecount_kyocer.Tot_A4%type;
        nTot_B5PreviousDay ss_pagecount_kyocer.Tot_B5%type;
        nTot_A5PreviousDay ss_pagecount_kyocer.Tot_A5%type;
        nTot_FolioPreviousDay ss_pagecount_kyocer.Tot_Folio%type;
        nTot_LedgerPreviousDay ss_pagecount_kyocer.Tot_Ledger%type;
        nTot_LegalPreviousDay ss_pagecount_kyocer.Tot_Legal%type;
        nTot_LetterPreviousDay ss_pagecount_kyocer.Tot_Letter%type;
        nTot_StatementPreviousDay ss_pagecount_kyocer.Tot_Statement%type;
        nTot_Banner1PreviousDay ss_pagecount_kyocer.Tot_Banner1%type;
        nTot_Banner2PreviousDay ss_pagecount_kyocer.Tot_Banner2%type;
        nTot_Other1PreviousDay ss_pagecount_kyocer.Tot_Other1%type;
        nTot_Other2PreviousDay ss_pagecount_kyocer.Tot_Other2%type;
        nBW_A3PreviousDay ss_pagecount_kyocer.BW_A3%type;
        nBW_B4PreviousDay ss_pagecount_kyocer.BW_B4%type;
        nBW_A4PreviousDay ss_pagecount_kyocer.BW_A4%type;
        nBW_B5PreviousDay ss_pagecount_kyocer.BW_B5%type;
        nBW_A5PreviousDay ss_pagecount_kyocer.BW_A5%type;
        nBW_FolioPreviousDay ss_pagecount_kyocer.BW_Folio%type;
        nBW_LedgerPreviousDay ss_pagecount_kyocer.BW_Ledger%type;
        nBW_LegalPreviousDay ss_pagecount_kyocer.BW_Legal%type;
        nBW_LetterPreviousDay ss_pagecount_kyocer.BW_Letter%type;
        nBW_StatementPreviousDay ss_pagecount_kyocer.BW_Statement%type;
        nBW_Banner1PreviousDay ss_pagecount_kyocer.BW_Banner1%type;
        nBW_Banner2PreviousDay ss_pagecount_kyocer.BW_Banner2%type;
        nBW_Other1PreviousDay ss_pagecount_kyocer.BW_Other1%type;
        nBW_Other2PreviousDay ss_pagecount_kyocer.BW_Other2%type;
        nColor_A3PreviousDay ss_pagecount_kyocer.Color_A3%type;
        nColor_B4PreviousDay ss_pagecount_kyocer.Color_B4%type;
        nColor_A4PreviousDay ss_pagecount_kyocer.Color_A4%type;
        nColor_B5PreviousDay ss_pagecount_kyocer.Color_B5%type;
        nColor_A5PreviousDay ss_pagecount_kyocer.Color_A5%type;
        nColor_FolioPreviousDay ss_pagecount_kyocer.Color_Folio%type;
        nColor_LedgerPreviousDay ss_pagecount_kyocer.Color_Ledger%type;
        nColor_LegalPreviousDay ss_pagecount_kyocer.Color_Legal%type;
        nColor_LetterPreviousDay ss_pagecount_kyocer.Color_Letter%type;
        nColor_StatementPreviousDay ss_pagecount_kyocer.color_statement%type;
        nColor_Banner1PreviousDay ss_pagecount_kyocer.color_banner1%type;
        nColor_Banner2PreviousDay ss_pagecount_kyocer.color_banner2%type;
        nColor_Other1PreviousDay ss_pagecount_kyocer.color_other1%type;
        nColor_Other2PreviousDay ss_pagecount_kyocer.color_other2%type;  

        Cursor cur_kyocera_manual Is 
            Select prn_queue, Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
            Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
            Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
            Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
            Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
            Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
            Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2, manual_entry_id, prn_online 
            From Ss_Pagecount_kyocer_manual 
            Where entry_Date = pEntryDate  
            And prn_queue = Trim(pPrnQueue) 	          
            For Update Of tot_a3_daily, tot_b4_daily, tot_a4_daily, tot_b5_daily, tot_a5_daily, tot_folio_daily, tot_ledger_daily, tot_legal_daily, tot_letter_daily,
                          tot_statement_daily, tot_banner1_daily, tot_banner2_daily, tot_other1_daily, tot_other2_daily, bw_a3_daily, bw_b4_daily, bw_a4_daily, bw_b5_daily,
                          bw_a5_daily, bw_folio_daily, bw_ledger_daily, bw_legal_daily, bw_letter_daily, bw_statement_daily, bw_banner1_daily, bw_banner2_daily, bw_other1_daily,
                          bw_other2_daily, color_a3_daily, color_b4_daily, color_a4_daily, color_b5_daily, color_a5_daily, color_folio_daily, color_ledger_daily, color_legal_daily,
                          color_letter_daily, color_statement_daily, color_banner1_daily, color_banner2_daily, color_other1_daily, color_other2_daily;
    Begin               
        For c2 In cur_kyocera_manual Loop        
            Begin
                Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                    Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                    Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                    Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                    Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                    Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                    Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                    nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                    nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                    nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                    nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                    nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                    From Ss_Pagecount_kyocer 
                    Where manual_entry_id = c2.manual_entry_id                    
                    And prn_online = 1;

                Update ss_pagecount_kyocer
                Set tot_a3_daily = nTot_A3PreviousDay - c2.tot_a3,
                    tot_b4_daily = nTot_B4PreviousDay - c2.tot_b4,
                    tot_a4_daily = nTot_A4PreviousDay - c2.tot_a4,
                    tot_b5_daily = nTot_B5PreviousDay - c2.tot_b5,
                    tot_a5_daily = nTot_A5PreviousDay - c2.tot_a5,
                    tot_folio_daily = nTot_FolioPreviousDay - c2.tot_folio,
                    tot_ledger_daily = nTot_LedgerPreviousDay - c2.tot_ledger,
                    tot_legal_daily = nTot_LegalPreviousDay - c2.tot_legal,
                    tot_letter_daily = nTot_LetterPreviousDay - c2.tot_letter,
                    tot_statement_daily = nTot_StatementPreviousDay - c2.tot_statement,
                    tot_banner1_daily = nTot_Banner1PreviousDay - c2.tot_banner1,
                    tot_banner2_daily = nTot_Banner2PreviousDay - c2.tot_banner2,
                    tot_other1_daily = nTot_Other1PreviousDay - c2.tot_other1,
                    tot_other2_daily = nTot_Other2PreviousDay - c2.tot_other2,
                    bw_a3_daily = nBW_A3PreviousDay - c2.bw_a3,
                    bw_b4_daily = nBW_B4PreviousDay - c2.bw_b4,
                    bw_a4_daily = nBW_A4PreviousDay - c2.bw_a4,
                    bw_b5_daily = nBW_B5PreviousDay - c2.bw_b5,
                    bw_a5_daily = nBW_A5PreviousDay - c2.bw_a5,
                    bw_folio_daily = nBW_FolioPreviousDay - c2.bw_folio,
                    bw_ledger_daily = nBW_LedgerPreviousDay - c2.bw_ledger,
                    bw_legal_daily = nBW_LegalPreviousDay - c2.bw_legal,
                    bw_letter_daily = nBW_LetterPreviousDay - c2.bw_letter,
                    bw_statement_daily = nBW_StatementPreviousDay - c2.bw_statement,
                    bw_banner1_daily = nBW_Banner1PreviousDay - c2.bw_banner1,
                    bw_banner2_daily = nBW_Banner2PreviousDay - c2.bw_banner2,
                    bw_other1_daily = nBW_Other1PreviousDay - c2.bw_other1,
                    bw_other2_daily = nBW_Other2PreviousDay - c2.bw_other2,
                    color_a3_daily = nColor_A3PreviousDay - c2.color_a3,
                    color_b4_daily = nColor_B4PreviousDay - c2.color_b4,
                    color_a4_daily = nColor_A4PreviousDay - c2.color_a4,
                    color_b5_daily = nColor_B5PreviousDay - c2.color_b5,
                    color_a5_daily = nColor_A5PreviousDay - c2.color_a5,
                    color_folio_daily = nColor_FolioPreviousDay - c2.color_folio,
                    color_ledger_daily = nColor_LedgerPreviousDay - c2.color_ledger, 
                    color_legal_daily = nColor_LegalPreviousDay - c2.color_legal,
                    color_letter_daily = nColor_LetterPreviousDay - c2.color_letter,
                    color_statement_daily = nColor_StatementPreviousDay - c2.color_statement,
                    color_banner1_daily = nColor_Banner1PreviousDay - c2.color_banner1,
                    color_banner2_daily = nColor_Banner2PreviousDay - c2.color_banner2,
                    color_other1_daily = nColor_Other1PreviousDay - c2.color_other1,
                    color_other2_daily = nColor_Other2PreviousDay - c2.color_other2 
                Where manual_entry_id = c2.manual_entry_id;
          Exception
              When No_Data_Found Then   
                  Begin
                      Select Nvl(tot_a3,0) tot_a3, Nvl(tot_b4, 0) tot_b4, Nvl(tot_a4, 0) tot_a4, Nvl(tot_b5, 0) tot_b5, Nvl(tot_a5, 0) tot_a5, Nvl(tot_folio, 0) tot_folio, Nvl(tot_ledger, 0) tot_ledger, 
                        Nvl(tot_legal, 0) tot_legal, Nvl(tot_letter, 0) tot_letter, Nvl(tot_statement, 0) tot_statement, Nvl(tot_banner1, 0) tot_banner1, Nvl(tot_banner2, 0) tot_banner2, Nvl(tot_other1, 0) tot_other1,
                        Nvl(tot_other2, 0) tot_other2, Nvl(bw_a3, 0) bw_a3, Nvl(bw_b4, 0) bw_b4, Nvl(bw_a4, 0) bw_a4, Nvl(bw_b5, 0) bw_b5, Nvl(bw_a5, 0) bw_a5, Nvl(bw_folio, 0) bw_folio, Nvl(bw_ledger, 0) bw_ledger, 
                        Nvl(bw_legal, 0) bw_legal, Nvl(bw_letter, 0) bw_letter, Nvl(bw_statement, 0) bw_statement, Nvl(bw_banner1, 0) bw_banner1, Nvl(bw_banner2, 0) bw_banner2, Nvl(bw_other1, 0) bw_other1,
                        Nvl(bw_other2, 0) bw_other2, Nvl(color_a3, 0) color_a3, Nvl(color_b4, 0) color_b4, Nvl(color_a4, 0) color_a4, Nvl(color_b5, 0) color_b5, Nvl(color_a5, 0) color_a5, Nvl(color_folio, 0) color_folio,
                        Nvl(color_ledger, 0) color_ledger, Nvl(color_legal, 0) color_legal, Nvl(color_letter, 0) color_letter, Nvl(color_statement, 0) color_statement, Nvl(color_banner1, 0) color_banner1,
                        Nvl(color_banner2, 0) color_banner2, Nvl(color_other1, 0) color_other1, Nvl(color_other2, 0) color_other2 Into
                        nTot_A3PreviousDay, nTot_B4PreviousDay, nTot_A4PreviousDay, nTot_B5PreviousDay, nTot_A5PreviousDay, nTot_FolioPreviousDay, nTot_LedgerPreviousDay, nTot_LegalPreviousDay, nTot_LetterPreviousDay,
                        nTot_StatementPreviousDay, nTot_Banner1PreviousDay, nTot_Banner2PreviousDay, nTot_Other1PreviousDay, nTot_Other2PreviousDay, nBW_A3PreviousDay, nBW_B4PreviousDay, nBW_A4PreviousDay, nBW_B5PreviousDay,
                        nBW_A5PreviousDay, nBW_FolioPreviousDay, nBW_LedgerPreviousDay, nBW_LegalPreviousDay, nBW_LetterPreviousDay, nBW_StatementPreviousDay, nBW_Banner1PreviousDay, nBW_Banner2PreviousDay, nBW_Other1PreviousDay,
                        nBW_Other2PreviousDay, nColor_A3PreviousDay, nColor_B4PreviousDay, nColor_A4PreviousDay, nColor_B5PreviousDay, nColor_A5PreviousDay, nColor_FolioPreviousDay, nColor_LedgerPreviousDay, nColor_LegalPreviousDay,
                        nColor_LetterPreviousDay, nColor_StatementPreviousDay, nColor_Banner1PreviousDay, nColor_Banner2PreviousDay, nColor_Other1PreviousDay, nColor_Other2PreviousDay
                        From Ss_Pagecount_kyocer 
                        Where prn_queue = Trim(c2.prn_queue)
                        And entry_Date = (Select Max(entry_date) From Ss_Pagecount_kyocer Where prn_queue = Trim(c2.prn_queue) And entry_Date < pEntryDate And prn_online = 1)
                        And prn_online = 1;

                      Update ss_pagecount_kyocer_manual
                        Set tot_a3_daily = c2.tot_a3 - nTot_A3PreviousDay,
                        tot_b4_daily = c2.tot_b4 - nTot_B4PreviousDay,
                        tot_a4_daily = c2.tot_a4 - nTot_A4PreviousDay,
                        tot_b5_daily = c2.tot_b5 - nTot_B5PreviousDay,
                        tot_a5_daily = c2.tot_a5 - nTot_A5PreviousDay,
                        tot_folio_daily = c2.tot_folio - nTot_FolioPreviousDay,
                        tot_ledger_daily = c2.tot_ledger - nTot_LedgerPreviousDay,
                        tot_legal_daily = c2.tot_legal - nTot_LegalPreviousDay,
                        tot_letter_daily = c2.tot_letter - nTot_LetterPreviousDay,
                        tot_statement_daily = c2.tot_statement - nTot_StatementPreviousDay,
                        tot_banner1_daily = c2.tot_banner1 - nTot_Banner1PreviousDay,
                        tot_banner2_daily = c2.tot_banner2 - nTot_Banner2PreviousDay,
                        tot_other1_daily = c2.tot_other1 - nTot_Other1PreviousDay,
                        tot_other2_daily = c2.tot_other2 - nTot_Other2PreviousDay,
                        bw_a3_daily = c2.bw_a3 - nBW_A3PreviousDay,
                        bw_b4_daily = c2.bw_b4 - nBW_B4PreviousDay,
                        bw_a4_daily = c2.bw_a4 - nBW_A4PreviousDay,
                        bw_b5_daily = c2.bw_b5 - nBW_B5PreviousDay,
                        bw_a5_daily = c2.bw_a5 - nBW_A5PreviousDay,
                        bw_folio_daily = c2.bw_folio - nBW_FolioPreviousDay,
                        bw_ledger_daily = c2.bw_ledger - nBW_LedgerPreviousDay,
                        bw_legal_daily = c2.bw_legal - nBW_LegalPreviousDay,
                        bw_letter_daily = c2.bw_letter - nBW_LetterPreviousDay,
                        bw_statement_daily = c2.bw_statement - nBW_StatementPreviousDay,
                        bw_banner1_daily = c2.bw_banner1 - nBW_Banner1PreviousDay,
                        bw_banner2_daily = c2.bw_banner2 - nBW_Banner2PreviousDay,
                        bw_other1_daily = c2.bw_other1 - nBW_Other1PreviousDay,
                        bw_other2_daily = c2.bw_other2 - nBW_Other2PreviousDay,
                        color_a3_daily = c2.color_a3 - nColor_A3PreviousDay,
                        color_b4_daily = c2.color_b4 - nColor_B4PreviousDay,
                        color_a4_daily = c2.color_a4 - nColor_A4PreviousDay,
                        color_b5_daily = c2.color_b5 - nColor_B5PreviousDay,
                        color_a5_daily = c2.color_a5 - nColor_A5PreviousDay,
                        color_folio_daily = c2.color_folio - nColor_FolioPreviousDay,
                        color_ledger_daily = c2.color_ledger - nColor_LedgerPreviousDay,
                        color_legal_daily = c2.color_legal - nColor_LegalPreviousDay,
                        color_letter_daily = c2.color_letter - nColor_LetterPreviousDay,
                        color_statement_daily = c2.color_statement - nColor_StatementPreviousDay,
                        color_banner1_daily = c2.color_banner1 - nColor_Banner1PreviousDay,
                        color_banner2_daily = c2.color_banner2 - nColor_Banner2PreviousDay,
                        color_other1_daily = c2.color_other1 - nColor_Other1PreviousDay,
                        color_other2_daily = c2.color_other2 - nColor_Other2PreviousDay
                    Where Current Of cur_kyocera_manual;                    
                Exception
                    When No_Data_Found Then
                      Null;    
                End;
            End; 
        End Loop;
        Commit;
    End;    

    Procedure sendDuplicateMail(metroEntryDate Varchar2) Is
        vFrom      Varchar2(80) := 'selfservice@tecnimont.in';
        --vRecipient Varchar2(80) := 's.kanakath@tecnimont.in';
        vRecipient Varchar2(80) := 'r.ganbavale@tecnimont.in';
        vCc Varchar2(80) := 's.kanakath@tecnimont.in';
        vSubject   Varchar2(80) := 'Details of Duplicate Print Queues';
        vMailHost Varchar2(30) := 'ticbexhcn1.ticb.comp';
        vMailConn utl_smtp.Connection;        
        vFileContent  Long;
        vPlainText Varchar2(4000);
        lBoundary    varchar2(100) := '****************************************************************************************************';
        Cursor cur_canon Is Select ipaddress, prn_queue, Office, Floor, wing From ss_pagecount_canon Where prn_queue In 
                            (Select prn_queue From ss_pagecount_canon Where prn_online = 1 And entry_date = Trim(metroEntryDate) Group by prn_queue Having count(prn_queue) > 1)	 
                            And entry_date = Trim(metroEntryDate)
                            Order By prn_queue, ipaddress;
        Cursor cur_kyocera Is Select ipaddress, prn_queue, Office, Floor, wing From ss_pagecount_kyocer Where prn_queue In 
                            (Select prn_queue From ss_pagecount_kyocer Where prn_online = 1 And entry_date = Trim(metroEntryDate) Group by prn_queue Having count(prn_queue) > 1)	 
                            And entry_date = Trim(metroEntryDate)
                            Order By prn_queue, ipaddress;        
    Begin        
        vPlainText := vPlainText || Chr(10) ||'Hello,';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Please find the attached List of Duplicate Print Queues.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Thanks and Regards,';
        vPlainText := vPlainText || Chr(10) || 'Network Printer Data Application.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || lBoundary;
        vPlainText := vPlainText || Chr(10) || 'This is an automatically generated email. Please do not reply to it.';

        vFileContent := 'Canon -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing'; 
        For c1 In cur_canon Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing;
        End Loop;
        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || 'Kyocera -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing'; 
        For c1 In cur_kyocera Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing;
        End Loop;
        vMailConn := UTL_SMTP.Open_Connection(vMailHost, 25);
        UTL_SMTP.Helo(vMailConn, vMailHost);
        UTL_SMTP.Mail(vMailConn, vFrom);
        UTL_SMTP.Rcpt(vMailConn, vRecipient);
        UTL_SMTP.Rcpt(vMailConn, vCc);
        UTL_SMTP.Open_Data(vMailConn);
        UTL_SMTP.Write_Data(vMailConn, 'Date: ' || To_Char(Sysdate, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'To: '   || vRecipient || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Cc: '   || vCc || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'From: ' || vFrom || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Subject: '|| vSubject || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: multipart/mixed; boundary="' || lBoundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);           
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, vPlainText || UTL_TCP.crlf || UTL_TCP.crlf);                
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, ' name='||metroEntryDate||'".csv"'  || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Transfer_Encoding: 8bit' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Disposition: attachment;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, 'filename='||metroEntryDate||'".csv"' || UTL_TCP.crlf|| UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, vFileContent || UTL_TCP.crlf || UTL_TCP.crlf);        
        UTL_SMTP.Close_Data(vMailConn);    
        UTL_SMTP.Quit(vMailConn);               
    Exception
        When utl_smtp.Transient_Error OR utl_smtp.Permanent_Error Then
            Raise_Application_Error(-20000, 'Unable to send mail', True);            
    End; 

    Procedure sendDataErrorMail(metroEntryDate Varchar2) Is
        vFrom      Varchar2(80) := 'selfservice@tecnimont.in';
        --vRecipient Varchar2(80) := 's.kanakath@tecnimont.in';
        vRecipient Varchar2(80) := 'r.ganbavale@tecnimont.in';
        vCc Varchar2(80) := 's.kanakath@tecnimont.in';
        vSubject   Varchar2(80) := 'Details of Duplicate Print Queues';
        vMailHost Varchar2(30) := 'ticbexhcn1.ticb.comp';
        vMailConn utl_smtp.Connection;        
        vFileContent  Long;
        vPlainText Varchar2(4000);
        lBoundary    varchar2(100) := '****************************************************************************************************';
        Cursor cur_canon Is Select ipaddress, prn_queue, Office, Floor, wing, location From ss_pagecount_canon 
                            Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = Trim(metroEntryDate)                            
                            Order By prn_queue, ipaddress;
        Cursor cur_kyocera Is Select ipaddress, prn_queue, Office, Floor, wing, location From ss_pagecount_kyocer 
                            Where (prn_queue = 'ERR' or office = 'ERR' or floor = 'ERR' or wing = 'ERR' or location = 'ERR') And entry_date = Trim(metroEntryDate)                            
                            Order By prn_queue, ipaddress;
    Begin        
        vPlainText := vPlainText || Chr(10) ||'Hello,';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Please find the attached List of Print Queues having errors. Kindly update Sharepoint site.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || 'Thanks and Regards,';
        vPlainText := vPlainText || Chr(10) || 'Network Printer Data Application.';
        vPlainText := vPlainText || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || Chr(10) || lBoundary;
        vPlainText := vPlainText || Chr(10) || 'This is an automatically generated email. Please do not reply to it.';

        vFileContent := 'Canon -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing,location'; 
        For c1 In cur_canon Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing||','|| c1.location;
        End Loop;
        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || ' ';
        vFileContent := vFileContent || Chr(10) || 'Kyocera -';
        vFileContent := vFileContent || Chr(10) || 'IP Address,Printer Queue,Office,Floor,Wing,location'; 
        For c1 In cur_kyocera Loop
            vFileContent := vFileContent || Chr(10) || c1.ipaddress ||','|| c1.prn_queue ||','|| c1.office ||','|| c1.floor ||','|| c1.wing||','|| c1.location;
        End Loop;
        vMailConn := UTL_SMTP.Open_Connection(vMailHost, 25);
        UTL_SMTP.Helo(vMailConn, vMailHost);
        UTL_SMTP.Mail(vMailConn, vFrom);
        UTL_SMTP.Rcpt(vMailConn, vRecipient);
        UTL_SMTP.Rcpt(vMailConn, vCc);
        UTL_SMTP.Open_Data(vMailConn);
        UTL_SMTP.Write_Data(vMailConn, 'Date: ' || To_Char(Sysdate, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'To: '   || vRecipient || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Cc: '   || vCc || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'From: ' || vFrom || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Subject: '|| vSubject || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'MIME-Version: 1.0' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: multipart/mixed; boundary="' || lBoundary || '"' || UTL_TCP.crlf || UTL_TCP.crlf);           
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain; charset="iso-8859-1"' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, vPlainText || UTL_TCP.crlf || UTL_TCP.crlf);                
        UTL_SMTP.Write_Data(vMailConn, '--' || lBoundary || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Type: text/plain;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, ' name='||metroEntryDate||'".csv"'  || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Transfer_Encoding: 8bit' || UTL_TCP.crlf);
        UTL_SMTP.Write_Data(vMailConn, 'Content-Disposition: attachment;' || UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, 'filename='||metroEntryDate||'".csv"' || UTL_TCP.crlf|| UTL_TCP.crlf);        
        UTL_SMTP.Write_Data(vMailConn, vFileContent || UTL_TCP.crlf || UTL_TCP.crlf);        
        UTL_SMTP.Close_Data(vMailConn);    
        UTL_SMTP.Quit(vMailConn);               
    Exception
        When utl_smtp.Transient_Error OR utl_smtp.Permanent_Error Then
            Raise_Application_Error(-20000, 'Unable to send mail', True);            
    End; 

    Procedure updatePrinterQueue(entryDate Varchar2) Is         
        Cursor cur_canon Is Select * From ss_pagecount_canon 
                            Where entry_date = Trim(entryDate) 
                            For Update of total, blacklarge, blacksmall, colorlarge, colorsmall, total2sided, total2;
        Cursor cur_kyocera Is Select * From ss_pagecount_kyocer 
                            Where entry_date = Trim(entryDate) 
                            For Update of tot_a3, tot_b4, tot_a4, tot_b5, tot_a5, tot_folio, tot_ledger, tot_legal, tot_letter, tot_statement, tot_banner1, tot_banner2, 
                                            tot_other1, tot_other2, bw_a3, bw_b4, bw_a4, bw_b5, bw_a5, bw_folio, bw_ledger, bw_legal, bw_letter, bw_statement, bw_banner1,
                                            bw_banner2, bw_other1, bw_other2, color_a3, color_b4, color_a4, color_b5, color_a5, color_folio, color_ledger, color_legal,
                                            color_letter, color_statement, color_banner1, color_banner2, color_other1, color_other2;                 

        ntotal ss_pagecount_canon.total%type;
        nblacklarge ss_pagecount_canon.blacklarge%type;
        nblacksmall ss_pagecount_canon.blacksmall%type;
        ncolorlarge ss_pagecount_canon.colorlarge%type;
        ncolorsmall ss_pagecount_canon.colorsmall%type;
        ntotal2sided ss_pagecount_canon.total2sided%type;
        ntotal2 ss_pagecount_canon.total2%type;
        ntot_a3                           number(10);    
        ntot_b4                           number(10);    
        ntot_a4                           number(10);    
        ntot_b5                           number(10);    
        ntot_a5                           number(10);    
        ntot_folio                        number(10);    
        ntot_ledger                       number(10);    
        ntot_legal                        number(10);    
        ntot_letter                       number(10);    
        ntot_statement                    number(10);    
        ntot_banner1                      number(10);    
        ntot_banner2                      number(10);    
        ntot_other1                       number(10);    
        ntot_other2                       number(10);    
        nbw_a3                            number(10);    
        nbw_b4                            number(10);    
        nbw_a4                            number(10);    
        nbw_b5                            number(10);    
        nbw_a5                            number(10);    
        nbw_folio                         number(10);    
        nbw_ledger                        number(10);    
        nbw_legal                         number(10);    
        nbw_letter                        number(10);    
        nbw_statement                     number(10);    
        nbw_banner1                       number(10);    
        nbw_banner2                       number(10);    
        nbw_other1                        number(10);    
        nbw_other2                        number(10);    
        ncolor_a3                         number(10);    
        ncolor_b4                         number(10);    
        ncolor_a4                         number(10);    
        ncolor_b5                         number(10);    
        ncolor_a5                         number(10);    
        ncolor_folio                      number(10);    
        ncolor_ledger                     number(10);    
        ncolor_legal                      number(10);    
        ncolor_letter                     number(10);    
        ncolor_statement                  number(10);    
        ncolor_banner1                    number(10);    
        ncolor_banner2                    number(10);    
        ncolor_other1                     number(10);    
        ncolor_other2                     number(10);    
    Begin
        Delete From ss_pagecount_canon_temp;
        Insert Into ss_pagecount_canon_temp
            Select ipaddress, ListAgg(prn_queue, ' - ') Within Group (Order By ipaddress, prn_queue) "PrinterQueue"
                From ss_pagecount_canon Where entry_date = entryDate
                Group by ipaddress;

        Delete From ss_pagecount_kyocer_temp;
        Insert Into ss_pagecount_kyocer_temp
            Select ipaddress, ListAgg(prn_queue, ' - ') Within Group (Order By ipaddress, prn_queue) "PrinterQueue"
                From ss_pagecount_kyocer Where entry_date = entryDate
                Group by ipaddress;
        Commit;

        Update ss_pagecount_canon a
            Set prn_queue = (Select prn_queue From ss_pagecount_canon_temp b Where b.ipaddress = a.ipaddress)
            Where a.entry_date = entryDate;

        For c1 In cur_canon Loop
            Begin
                Select Greatest(Nvl(a.total, 0), Nvl(b.total, 0)) total,
                        Greatest(Nvl(a.blacklarge, 0), Nvl(b.blacklarge, 0)) blacklarge,
                        Greatest(Nvl(a.blacksmall, 0), Nvl(b.blacksmall, 0)) blacksmall,
                        Greatest(Nvl(a.colorlarge, 0), Nvl(b.colorlarge, 0)) colorlarge,
                        Greatest(Nvl(a.colorsmall, 0), Nvl(b.colorsmall, 0)) colorsmall,
                        Greatest(Nvl(a.total2sided, 0), Nvl(b.total2sided, 0)) total2sided,
                        Greatest(Nvl(a.total2, 0), Nvl(b.total2, 0)) total2
                        Into ntotal, nblacklarge, nblacksmall, ncolorlarge, ncolorsmall, ntotal2sided, ntotal2
                From ss_pagecount_canon a, ss_pagecount_canon b
                Where a.entry_date = b.entry_date
                And a.ipaddress = b.ipaddress
                And a.prn_queue = b.prn_queue
                And a.entry_date = Trim(c1.entry_date)
                And a.prn_queue = Trim(c1.prn_queue);        

                update ss_pagecount_canon
                    set total = ntotal,
                        blacklarge = nblacklarge,
                        blacksmall = nblacksmall,
                        colorlarge = ncolorlarge,
                        colorsmall = nblacksmall,
                        total2sided = ntotal2sided,
                        total2 = ntotal2
                        Where current of cur_canon;
            Exception
                When Others Then
                    Null;
            End;
        End Loop;
        Commit;     

        Update ss_pagecount_kyocer a
            Set prn_queue = (Select prn_queue From ss_pagecount_kyocer_temp b Where b.ipaddress = a.ipaddress)
            Where a.entry_date = entryDate;

        For c1 In cur_kyocera Loop
            Begin
                Select Greatest(Nvl(a.tot_a3, 0), Nvl(b.tot_a3, 0)) tot_a3,
                        Greatest(Nvl(a.tot_b4, 0), Nvl(b.tot_b4, 0)) tot_b4,
                        Greatest(Nvl(a.tot_a4, 0), Nvl(b.tot_a4, 0)) tot_a4,
						Greatest(Nvl(a.tot_b5, 0), Nvl(b.tot_b5, 0)) tot_b5,
						Greatest(Nvl(a.tot_a5, 0), Nvl(b.tot_a5, 0)) tot_a5,
						Greatest(Nvl(a.tot_folio, 0), Nvl(b.tot_folio, 0)) tot_folio,
						Greatest(Nvl(a.tot_ledger, 0), Nvl(b.tot_ledger, 0)) tot_ledger,
						Greatest(Nvl(a.tot_legal, 0), Nvl(b.tot_legal, 0)) tot_legal,
						Greatest(Nvl(a.tot_letter, 0), Nvl(b.tot_letter, 0)) tot_letter,
						Greatest(Nvl(a.tot_statement, 0), Nvl(b.tot_statement, 0)) tot_statement,
						Greatest(Nvl(a.tot_banner1, 0), Nvl(b.tot_banner1, 0)) tot_banner1,
						Greatest(Nvl(a.tot_banner2, 0), Nvl(b.tot_banner2, 0)) tot_banner2,
						Greatest(Nvl(a.tot_other1, 0), Nvl(b.tot_other1, 0)) tot_other1,
						Greatest(Nvl(a.tot_other2, 0), Nvl(b.tot_other2, 0)) tot_other2,
						Greatest(Nvl(a.bw_a3, 0), Nvl(b.bw_a3, 0)) bw_a3,
                        Greatest(Nvl(a.bw_b4, 0), Nvl(b.bw_b4, 0)) bw_b4,
                        Greatest(Nvl(a.bw_a4, 0), Nvl(b.bw_a4, 0)) bw_a4,
						Greatest(Nvl(a.bw_b5, 0), Nvl(b.bw_b5, 0)) bw_b5,
						Greatest(Nvl(a.bw_a5, 0), Nvl(b.bw_a5, 0)) bw_a5,
						Greatest(Nvl(a.bw_folio, 0), Nvl(b.bw_folio, 0)) bw_folio,
						Greatest(Nvl(a.bw_ledger, 0), Nvl(b.bw_ledger, 0)) bw_ledger,
						Greatest(Nvl(a.bw_legal, 0), Nvl(b.bw_legal, 0)) bw_legal,
						Greatest(Nvl(a.bw_letter, 0), Nvl(b.bw_letter, 0)) bw_letter,
						Greatest(Nvl(a.bw_statement, 0), Nvl(b.bw_statement, 0)) bw_statement,
						Greatest(Nvl(a.bw_banner1, 0), Nvl(b.bw_banner1, 0)) bw_banner1,
						Greatest(Nvl(a.bw_banner2, 0), Nvl(b.bw_banner2, 0)) bw_banner2,
						Greatest(Nvl(a.bw_other1, 0), Nvl(b.bw_other1, 0)) bw_other1,
						Greatest(Nvl(a.bw_other2, 0), Nvl(b.bw_other2, 0)) bw_other2,						
						Greatest(Nvl(a.color_a3, 0), Nvl(b.color_a3, 0)) color_a3,
                        Greatest(Nvl(a.color_b4, 0), Nvl(b.color_b4, 0)) color_b4,
                        Greatest(Nvl(a.color_a4, 0), Nvl(b.color_a4, 0)) color_a4,
						Greatest(Nvl(a.color_b5, 0), Nvl(b.color_b5, 0)) color_b5,
						Greatest(Nvl(a.color_a5, 0), Nvl(b.color_a5, 0)) color_a5,
						Greatest(Nvl(a.color_folio, 0), Nvl(b.color_folio, 0)) color_folio,
						Greatest(Nvl(a.color_ledger, 0), Nvl(b.color_ledger, 0)) color_ledger,
						Greatest(Nvl(a.color_legal, 0), Nvl(b.color_legal, 0)) color_legal,
						Greatest(Nvl(a.color_letter, 0), Nvl(b.color_letter, 0)) color_letter,
						Greatest(Nvl(a.color_statement, 0), Nvl(b.color_statement, 0)) color_statement,
						Greatest(Nvl(a.color_banner1, 0), Nvl(b.color_banner1, 0)) color_banner1,
						Greatest(Nvl(a.color_banner2, 0), Nvl(b.color_banner2, 0)) color_banner2,
						Greatest(Nvl(a.color_other1, 0), Nvl(b.color_other1, 0)) color_other1,
						Greatest(Nvl(a.color_other2, 0), Nvl(b.color_other2, 0)) color_other2
                        Into ntot_a3,ntot_b4,ntot_a4,ntot_b5,ntot_a5,ntot_folio,ntot_ledger,ntot_legal,ntot_letter,ntot_statement,ntot_banner1,
                        ntot_banner2,ntot_other1,ntot_other2,nbw_a3,nbw_b4,nbw_a4,nbw_b5,nbw_a5,nbw_folio,nbw_ledger,nbw_legal,nbw_letter,nbw_statement,nbw_banner1,nbw_banner2,
                        nbw_other1,nbw_other2,ncolor_a3,ncolor_b4,ncolor_a4,ncolor_b5,ncolor_a5,ncolor_folio,ncolor_ledger,ncolor_legal,ncolor_letter,ncolor_statement,
                        ncolor_banner1,ncolor_banner2,ncolor_other1,ncolor_other2
                From ss_pagecount_kyocer a, ss_pagecount_kyocer b
                Where a.entry_date = b.entry_date
                And a.ipaddress = b.ipaddress
                And a.prn_queue = b.prn_queue
                And a.entry_date = Trim(c1.entry_date)
                And a.prn_queue = Trim(c1.prn_queue);        

                Update ss_pagecount_kyocer
                    set tot_a3	=	ntot_a3,
                        tot_b4	=	ntot_b4,
                        tot_a4	=	ntot_a4,
                        tot_b5	=	ntot_b5,
                        tot_a5	=	ntot_a5,
                        tot_folio	=	ntot_folio,
                        tot_ledger	=	ntot_ledger,
                        tot_legal	=	ntot_legal,
                        tot_letter	=	ntot_letter,
                        tot_statement	=	ntot_statement,
                        tot_banner1	=	ntot_banner1,
                        tot_banner2	=	ntot_banner2,
                        tot_other1	=	ntot_other1,
                        tot_other2	=	ntot_other2,
                        bw_a3	=	nbw_a3,
                        bw_b4	=	nbw_b4,
                        bw_a4	=	nbw_a4,
                        bw_b5	=	nbw_b5,
                        bw_a5	=	nbw_a5,
                        bw_folio	=	nbw_folio,
                        bw_ledger	=	nbw_ledger,
                        bw_legal	=	nbw_legal,
                        bw_letter	=	nbw_letter,
                        bw_statement	=	nbw_statement,
                        bw_banner1	=	nbw_banner1,
                        bw_banner2	=	nbw_banner2,
                        bw_other1	=	nbw_other1,
                        bw_other2	=	nbw_other2,
                        color_a3	=	ncolor_a3,
                        color_b4	=	ncolor_b4,
                        color_a4	=	ncolor_a4,
                        color_b5	=	ncolor_b5,
                        color_a5	=	ncolor_a5,
                        color_folio	=	ncolor_folio,
                        color_ledger	=	ncolor_ledger,
                        color_legal	=	ncolor_legal,
                        color_letter	=	ncolor_letter,
                        color_statement	=	ncolor_statement,
                        color_banner1	=	ncolor_banner1,
                        color_banner2	=	ncolor_banner2,
                        color_other1	=	ncolor_other1,
                        color_other2	=	ncolor_other2
                    Where current of cur_kyocera;      
            Exception
                When Others Then
                    Null;
            End;
        End Loop;                                 

        Commit;
    End;

    Function getCanonKyoceraRecords(pEntryDate Varchar2) Return Number Is
        nCountCanon Number:=0;
        nCountKyocer Number:=0;    
    Begin
        Update ss_pagecount_canon Set entry_date = pEntryDate Where manual_entry_id Is Null And Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) And entry_date < pEntryDate;
        Update ss_pagecount_kyocer Set entry_date = pEntryDate Where manual_entry_id Is Null And Substr(entry_date,1,8) = Substr(pEntryDate,1, 8) And entry_date < pEntryDate;    
        Commit;

        Select Count(entry_date) Into nCountCanon From ss_pagecount_canon Where entry_date = pEntryDate And To_Number(Substr(entry_date,9,6)) > 183000 And prn_online = -1;
        Select Count(entry_date) Into nCountKyocer From ss_pagecount_kyocer Where entry_date = pEntryDate And To_Number(Substr(entry_date,9,6)) > 183000  And prn_online = -1;        

        If nCountCanon >= nCountKyocer Then
            Return nCountCanon;
        Else    
            Return nCountKyocer;
        End If;
    End;

    procedure y_temporary is 
        --cursor x is select distinct entry_date from ss_pagecount_canon where  to_number(entry_date) <= 20181107223000 order by entry_date;
        cursor x is select distinct entry_date from ss_pagecount_kyocer where to_number(entry_date) <= 20181107223000 order by entry_date;
    begin
        for c1 in x loop
            updatePrinterQueue(c1.entry_date);
            deleteDuplicateData(c1.entry_date);
        end loop;
    end;



     PROCEDURE x_kyocera_temporary IS

        CURSOR cur_kyocer IS
        SELECT
            entry_date,
            ipaddress,
            prn_queue,
            srno,
            hostname,
            prn_name,
            prn_online,
            office,
            floor,
            wing,
    --tot_a3,
    --tot_a3_daily,
            tot_a3 - LAG(tot_a3) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_a3_daily_srno,

    --tot_b4,
    --tot_b4_daily,
            tot_b4 - LAG(tot_b4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_b4_daily_srno,

    --tot_a4,
    --tot_a4_daily,
            tot_a4 - LAG(tot_a4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_a4_daily_srno,

    --tot_b5,
    --tot_b5_daily,
            tot_b5 - LAG(tot_b5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_b5_daily_srno,

    --tot_a5,
    --tot_a5_daily,
            tot_a5 - LAG(tot_a5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_a5_daily_srno,

    --tot_folio,
    --tot_folio_daily,
            tot_folio - LAG(tot_folio) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_folio_daily_srno,

    --tot_ledger,
    --tot_ledger_daily,
            tot_ledger - LAG(tot_ledger) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_ledger_daily_srno,

    --tot_legal,
    --tot_legal_daily,
            tot_legal - LAG(tot_legal) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_legal_daily_srno,    

    --tot_letter,
    --tot_letter_daily,
            tot_letter - LAG(tot_letter) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_letter_daily_srno,

    --tot_statement,
    --tot_statement_daily,
            tot_statement - LAG(tot_statement) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_statement_daily_srno,

    --tot_banner1,
    --tot_banner1_daily,
            tot_banner1 - LAG(tot_banner1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_banner1_daily_srno,

    --tot_banner2,
    --tot_banner2_daily,
            tot_banner2 - LAG(tot_banner2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_banner2_daily_srno,

    --tot_other1,
    --tot_other1_daily,
            tot_other1 - LAG(tot_other1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_other1_daily_srno,    

        --tot_other2,
    --tot_other2_daily,
            tot_other2 - LAG(tot_other2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) tot_other2_daily_srno,

    --bw_a3,
    --bw_a3_daily,
            bw_a3 - LAG(bw_a3) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_a3_daily_srno,

    --bw_b4,
    --bw_b4_daily,
            bw_b4 - LAG(bw_b4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_b4_daily_srno,

    --bw_a4,
    --bw_a4_daily,
            bw_a4 - LAG(bw_a4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_a4_daily_srno,

    --bw_b5,
    --bw_b5_daily,
            bw_b5 - LAG(bw_b5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_b5_daily_srno,

    --bw_a5,
    --bw_a5_daily,
            bw_a5 - LAG(bw_a5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_a5_daily_srno,

    --bw_folio,
    --bw_folio_daily,
            bw_folio - LAG(bw_folio) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_folio_daily_srno,

    --bw_ledger,
    --bw_ledger_daily,
            bw_ledger - LAG(bw_ledger) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_ledger_daily_srno,

    --bw_legal,
    --bw_legal_daily,
            bw_legal - LAG(bw_legal) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_legal_daily_srno,    

    --bw_letter,
    --bw_letter_daily,
            bw_letter - LAG(bw_letter) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_letter_daily_srno,

    --bw_statement,
    --bw_statement_daily,
            bw_statement - LAG(bw_statement) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_statement_daily_srno,

    --bw_banner1,
    --bw_banner1_daily,
            bw_banner1 - LAG(bw_banner1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_banner1_daily_srno,

    --bw_banner2,
    --bw_banner2_daily,
            bw_banner2 - LAG(bw_banner2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_banner2_daily_srno,

    --bw_other1,
    --bw_other1_daily,
            bw_other1 - LAG(bw_other1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_other1_daily_srno,    

    --bw_other2,
    --bw_other2_daily,
            bw_other2 - LAG(bw_other2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) bw_other2_daily_srno,

    --color_a3,
    --color_a3_daily,
            color_a3 - LAG(color_a3) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_a3_daily_srno,

    --color_b4,
    --color_b4_daily,
            color_b4 - LAG(color_b4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_b4_daily_srno,

    --color_a4,
    --color_a4_daily,
            color_a4 - LAG(color_a4) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_a4_daily_srno,

    --color_b5,
    --color_b5_daily,
            color_b5 - LAG(color_b5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_b5_daily_srno,

    --color_a5,
    --color_a5_daily,
            color_a5 - LAG(color_a5) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_a5_daily_srno,

    --color_folio,
    --color_folio_daily,
            color_folio - LAG(color_folio) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_folio_daily_srno,

    --color_ledger,
    --color_ledger_daily,
            color_ledger - LAG(color_ledger) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_ledger_daily_srno,

    --color_legal,
    --color_legal_daily,
            color_legal - LAG(color_legal) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_legal_daily_srno,    

    --color_letter,
    --color_letter_daily,
            color_letter - LAG(color_letter) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_letter_daily_srno,

    --color_statement,
    --color_statement_daily,
            color_statement - LAG(color_statement) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_statement_daily_srno,

    --color_banner1,
    --color_banner1_daily,
            color_banner1 - LAG(color_banner1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_banner1_daily_srno,

    --color_banner2,
    --color_banner2_daily,
            color_banner2 - LAG(color_banner2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_banner2_daily_srno,

    --color_other1,
    --color_other1_daily,
            color_other1 - LAG(color_other1) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_other1_daily_srno,    

    --color_other2,
    --color_other2_daily,
            color_other2 - LAG(color_other2) OVER(
                PARTITION BY srno
                ORDER BY
                    srno, entry_date
            ) color_other2_daily_srno
        FROM
            ss_pagecount_kyocer
        WHERE
            prn_online = 1
            AND srno IS NOT NULL
            --AND srno = 'LHU5Z01046'
            --AND to_number(entry_date) > 20181200000000
        ORDER BY
            srno,
            entry_date;

    BEGIN
        FOR c1 IN cur_kyocer LOOP UPDATE ss_pagecount_kyocer
        SET
            tot_a3_daily_srno = c1.tot_a3_daily_srno,
            tot_b4_daily_srno = c1.tot_b4_daily_srno,
            tot_a4_daily_srno = c1.tot_a4_daily_srno,
            tot_b5_daily_srno = c1.tot_b5_daily_srno,
            tot_a5_daily_srno = c1.tot_a5_daily_srno,
            tot_folio_daily_srno = c1.tot_folio_daily_srno,
            tot_ledger_daily_srno = c1.tot_ledger_daily_srno,
            tot_legal_daily_srno = c1.tot_legal_daily_srno,
            tot_letter_daily_srno = c1.tot_letter_daily_srno,
            tot_statement_daily_srno = c1.tot_statement_daily_srno,
            tot_banner1_daily_srno = c1.tot_banner1_daily_srno,
            tot_banner2_daily_srno = c1.tot_banner2_daily_srno,
            tot_other1_daily_srno = c1.tot_other1_daily_srno,
            tot_other2_daily_srno = c1.tot_other2_daily_srno,
            bw_a3_daily_srno = c1.bw_a3_daily_srno,
            bw_b4_daily_srno = c1.bw_b4_daily_srno,
            bw_a4_daily_srno = c1.bw_a4_daily_srno,
            bw_b5_daily_srno = c1.bw_b5_daily_srno,
            bw_a5_daily_srno = c1.bw_a5_daily_srno,
            bw_folio_daily_srno = c1.bw_folio_daily_srno,
            bw_ledger_daily_srno = c1.bw_ledger_daily_srno,
            bw_legal_daily_srno = c1.bw_legal_daily_srno,
            bw_letter_daily_srno = c1.bw_letter_daily_srno,
            bw_statement_daily_srno = c1.bw_statement_daily_srno,
            bw_banner1_daily_srno = c1.bw_banner1_daily_srno,
            bw_banner2_daily_srno = c1.bw_banner2_daily_srno,
            bw_other1_daily_srno = c1.bw_other1_daily_srno,
            bw_other2_daily_srno = c1.bw_other2_daily_srno,
            color_a3_daily_srno = c1.color_a3_daily_srno,
            color_b4_daily_srno = c1.color_b4_daily_srno,
            color_a4_daily_srno = c1.color_a4_daily_srno,
            color_b5_daily_srno = c1.color_b5_daily_srno,
            color_a5_daily_srno = c1.color_a5_daily_srno,
            color_folio_daily_srno = c1.color_folio_daily_srno,
            color_ledger_daily_srno = c1.color_ledger_daily_srno,
            color_legal_daily_srno = c1.color_legal_daily_srno,
            color_letter_daily_srno = c1.color_letter_daily_srno,
            color_statement_daily_srno = c1.color_statement_daily_srno,
            color_banner1_daily_srno = c1.color_banner1_daily_srno,
            color_banner2_daily_srno = c1.color_banner2_daily_srno,
            color_other1_daily_srno = c1.color_other1_daily_srno,
            color_other2_daily_srno = c1.color_other2_daily_srno
        WHERE
            entry_date = c1.entry_date
            AND srno = c1.srno;

        END LOOP;

        COMMIT;
    END;

    PROCEDURE x_kyocera_temporary_1 IS

        CURSOR cur_kyocer IS
        SELECT
            entry_date,
            ipaddress,
            prn_queue,
            srno,
            hostname,
            prn_name,
            prn_online,
            office,
            floor,
            wing,
    --tot_a3,
    --tot_a3_daily,
            tot_a3 - LAG(tot_a3) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_a3_daily,

    --tot_b4,
    --tot_b4_daily,
            tot_b4 - LAG(tot_b4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_b4_daily,

    --tot_a4,
    --tot_a4_daily,
            tot_a4 - LAG(tot_a4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_a4_daily,

    --tot_b5,
    --tot_b5_daily,
            tot_b5 - LAG(tot_b5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_b5_daily,

    --tot_a5,
    --tot_a5_daily,
            tot_a5 - LAG(tot_a5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_a5_daily,

    --tot_folio,
    --tot_folio_daily,
            tot_folio - LAG(tot_folio) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_folio_daily,

    --tot_ledger,
    --tot_ledger_daily,
            tot_ledger - LAG(tot_ledger) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_ledger_daily,

    --tot_legal,
    --tot_legal_daily,
            tot_legal - LAG(tot_legal) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_legal_daily,    

    --tot_letter,
    --tot_letter_daily,
            tot_letter - LAG(tot_letter) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_letter_daily,

    --tot_statement,
    --tot_statement_daily,
            tot_statement - LAG(tot_statement) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_statement_daily,

    --tot_banner1,
    --tot_banner1_daily,
            tot_banner1 - LAG(tot_banner1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_banner1_daily,

    --tot_banner2,
    --tot_banner2_daily,
            tot_banner2 - LAG(tot_banner2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_banner2_daily,

    --tot_other1,
    --tot_other1_daily,
            tot_other1 - LAG(tot_other1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_other1_daily,    

        --tot_other2,
    --tot_other2_daily,
            tot_other2 - LAG(tot_other2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) tot_other2_daily,

    --bw_a3,
    --bw_a3_daily,
            bw_a3 - LAG(bw_a3) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_a3_daily,

    --bw_b4,
    --bw_b4_daily,
            bw_b4 - LAG(bw_b4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_b4_daily,

    --bw_a4,
    --bw_a4_daily,
            bw_a4 - LAG(bw_a4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_a4_daily,

    --bw_b5,
    --bw_b5_daily,
            bw_b5 - LAG(bw_b5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_b5_daily,

    --bw_a5,
    --bw_a5_daily,
            bw_a5 - LAG(bw_a5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_a5_daily,

    --bw_folio,
    --bw_folio_daily,
            bw_folio - LAG(bw_folio) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_folio_daily,

    --bw_ledger,
    --bw_ledger_daily,
            bw_ledger - LAG(bw_ledger) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_ledger_daily,

    --bw_legal,
    --bw_legal_daily,
            bw_legal - LAG(bw_legal) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_legal_daily,    

    --bw_letter,
    --bw_letter_daily,
            bw_letter - LAG(bw_letter) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_letter_daily,

    --bw_statement,
    --bw_statement_daily,
            bw_statement - LAG(bw_statement) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_statement_daily,

    --bw_banner1,
    --bw_banner1_daily,
            bw_banner1 - LAG(bw_banner1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_banner1_daily,

    --bw_banner2,
    --bw_banner2_daily,
            bw_banner2 - LAG(bw_banner2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_banner2_daily,

    --bw_other1,
    --bw_other1_daily,
            bw_other1 - LAG(bw_other1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_other1_daily,    

    --bw_other2,
    --bw_other2_daily,
            bw_other2 - LAG(bw_other2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) bw_other2_daily,

    --color_a3,
    --color_a3_daily,
            color_a3 - LAG(color_a3) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_a3_daily,

    --color_b4,
    --color_b4_daily,
            color_b4 - LAG(color_b4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_b4_daily,

    --color_a4,
    --color_a4_daily,
            color_a4 - LAG(color_a4) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_a4_daily,

    --color_b5,
    --color_b5_daily,
            color_b5 - LAG(color_b5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_b5_daily,

    --color_a5,
    --color_a5_daily,
            color_a5 - LAG(color_a5) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_a5_daily,

    --color_folio,
    --color_folio_daily,
            color_folio - LAG(color_folio) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_folio_daily,

    --color_ledger,
    --color_ledger_daily,
            color_ledger - LAG(color_ledger) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_ledger_daily,

    --color_legal,
    --color_legal_daily,
            color_legal - LAG(color_legal) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_legal_daily,    

    --color_letter,
    --color_letter_daily,
            color_letter - LAG(color_letter) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_letter_daily,

    --color_statement,
    --color_statement_daily,
            color_statement - LAG(color_statement) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_statement_daily,

    --color_banner1,
    --color_banner1_daily,
            color_banner1 - LAG(color_banner1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_banner1_daily,

    --color_banner2,
    --color_banner2_daily,
            color_banner2 - LAG(color_banner2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_banner2_daily,

    --color_other1,
    --color_other1_daily,
            color_other1 - LAG(color_other1) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_other1_daily,    

    --color_other2,
    --color_other2_daily,
            color_other2 - LAG(color_other2) OVER(
                PARTITION BY prn_queue
                ORDER BY
                    prn_queue, entry_date
            ) color_other2_daily
        FROM
            ss_pagecount_kyocer
        WHERE
            prn_online = 1
            AND prn_queue IS NOT NULL
            --AND prn_queue = 'LHU5Z01046'
            --AND to_number(entry_date) > 20181200000000
        ORDER BY
            prn_queue,
            entry_date;

    BEGIN
        FOR c1 IN cur_kyocer LOOP UPDATE ss_pagecount_kyocer
        SET
            tot_a3_daily = c1.tot_a3_daily,
            tot_b4_daily = c1.tot_b4_daily,
            tot_a4_daily = c1.tot_a4_daily,
            tot_b5_daily = c1.tot_b5_daily,
            tot_a5_daily = c1.tot_a5_daily,
            tot_folio_daily = c1.tot_folio_daily,
            tot_ledger_daily = c1.tot_ledger_daily,
            tot_legal_daily = c1.tot_legal_daily,
            tot_letter_daily = c1.tot_letter_daily,
            tot_statement_daily = c1.tot_statement_daily,
            tot_banner1_daily = c1.tot_banner1_daily,
            tot_banner2_daily = c1.tot_banner2_daily,
            tot_other1_daily = c1.tot_other1_daily,
            tot_other2_daily = c1.tot_other2_daily,
            bw_a3_daily = c1.bw_a3_daily,
            bw_b4_daily = c1.bw_b4_daily,
            bw_a4_daily = c1.bw_a4_daily,
            bw_b5_daily = c1.bw_b5_daily,
            bw_a5_daily = c1.bw_a5_daily,
            bw_folio_daily = c1.bw_folio_daily,
            bw_ledger_daily = c1.bw_ledger_daily,
            bw_legal_daily = c1.bw_legal_daily,
            bw_letter_daily = c1.bw_letter_daily,
            bw_statement_daily = c1.bw_statement_daily,
            bw_banner1_daily = c1.bw_banner1_daily,
            bw_banner2_daily = c1.bw_banner2_daily,
            bw_other1_daily = c1.bw_other1_daily,
            bw_other2_daily = c1.bw_other2_daily,
            color_a3_daily = c1.color_a3_daily,
            color_b4_daily = c1.color_b4_daily,
            color_a4_daily = c1.color_a4_daily,
            color_b5_daily = c1.color_b5_daily,
            color_a5_daily = c1.color_a5_daily,
            color_folio_daily = c1.color_folio_daily,
            color_ledger_daily = c1.color_ledger_daily,
            color_legal_daily = c1.color_legal_daily,
            color_letter_daily = c1.color_letter_daily,
            color_statement_daily = c1.color_statement_daily,
            color_banner1_daily = c1.color_banner1_daily,
            color_banner2_daily = c1.color_banner2_daily,
            color_other1_daily = c1.color_other1_daily,
            color_other2_daily = c1.color_other2_daily
        WHERE
            entry_date = c1.entry_date
            AND prn_queue = c1.prn_queue;

        END LOOP;

        COMMIT;
    END;

    procedure x_canon_temporary is
    cursor cur_canon is 
    SELECT
    entry_date, ipaddress, prn_queue, srno, hostname, prn_name, prn_online, office, floor, wing,
    --total,
    --total_daily,
    total - LAG(total) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) total_daily_srno,

    --blacklarge,
    --blacklarge_daily,
    blacklarge - LAG(blacklarge) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) blacklarge_daily_srno,

    --blacksmall,
    --blacksmall_daily,
    blacksmall - LAG(blacksmall) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) blacksmall_daily_srno,

    --colorlarge,
    --colorlarge_daily,
    colorlarge - LAG(colorlarge) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) colorlarge_daily_srno,

    --colorsmall,
    --colorsmall_daily,
    colorsmall - LAG(colorsmall) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) colorsmall_daily_srno,

    --total2sided,
    --total2sided_daily,
    total2sided - LAG(total2sided) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) total2sided_daily_srno,

    --total2,
    --total2_daily,
    total2 - LAG(total2) OVER(
        PARTITION BY srno
        ORDER BY
            srno, entry_date
    ) total2_daily_srno

    FROM
        ss_pagecount_canon
    WHERE        
        prn_online = 1
        AND srno IS NOT NULL
        --AND srno = 'LHU5Z01046'
        --AND entry_date LIKE '201812%'
    ORDER BY
        srno,
        entry_date;

    begin    
        for c1 in cur_canon loop
            update ss_pagecount_canon
            set total_daily_srno = c1.total_daily_srno,
            blacklarge_daily_srno = c1.blacklarge_daily_srno,
            blacksmall_daily_srno = c1.blacksmall_daily_srno,
            colorlarge_daily_srno = c1.colorlarge_daily_srno,
            colorsmall_daily_srno = c1.colorsmall_daily_srno,
            total2sided_daily_srno = c1.total2sided_daily_srno,
            total2_daily_srno = c1.total2_daily_srno
            where entry_date = c1.entry_date
            and srno=c1.srno;
        end loop;
        commit;

    end;

    procedure x_canon_temporary_1 is
    cursor cur_canon is 
    SELECT
    entry_date, ipaddress, prn_queue, srno, hostname, prn_name, prn_online, office, floor, wing,
    --total,
    --total_daily,
    total - LAG(total) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) total_daily,

    --blacklarge,
    --blacklarge_daily,
    blacklarge - LAG(blacklarge) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) blacklarge_daily,

    --blacksmall,
    --blacksmall_daily,
    blacksmall - LAG(blacksmall) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) blacksmall_daily,

    --colorlarge,
    --colorlarge_daily,
    colorlarge - LAG(colorlarge) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) colorlarge_daily,

    --colorsmall,
    --colorsmall_daily,
    colorsmall - LAG(colorsmall) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) colorsmall_daily,

    --total2sided,
    --total2sided_daily,
    total2sided - LAG(total2sided) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) total2sided_daily,

    --total2,
    --total2_daily,
    total2 - LAG(total2) OVER(
        PARTITION BY prn_queue
        ORDER BY
            prn_queue, entry_date
    ) total2_daily

    FROM
        ss_pagecount_canon
    WHERE        
        prn_online = 1
        AND prn_queue IS NOT NULL
        --AND prn_queue = 'LHU5Z01046'
        --AND entry_date LIKE '201812%'
    ORDER BY
        prn_queue,
        entry_date;

    begin    
        for c1 in cur_canon loop
            update ss_pagecount_canon
            set total_daily = c1.total_daily,
            blacklarge_daily = c1.blacklarge_daily,
            blacksmall_daily = c1.blacksmall_daily,
            colorlarge_daily = c1.colorlarge_daily,
            colorsmall_daily = c1.colorsmall_daily,
            total2sided_daily = c1.total2sided_daily,
            total2_daily = c1.total2_daily
            where entry_date = c1.entry_date
            and prn_queue=c1.prn_queue;
        end loop;
        commit;

    end;


    FUNCTION loadPrintfrom RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              TO_CHAR(TO_DATE(substr(fromdatemonth, 1, 8), 'rrrrmmdd'), 'DD/MM/RRRR'),
                              fromdatemonth
                          FROM
                              ss_pagecount_dates
                          WHERE
                              fromdatemonth < (
                                  SELECT
                                      MAX(entry_date)
                                  FROM
                                      ss_pagecount_kyocer
                              );

        RETURN o_cursor;
    END;

    FUNCTION loadPrintTo RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              TO_CHAR(TO_DATE(substr(todatemonth, 1, 8), 'rrrrmmdd'), 'DD/MM/RRRR'),
                              todatemonth
                          FROM
                              ss_pagecount_dates
                          WHERE
                              fromdatemonth < (
                                  SELECT
                                      MAX(entry_date)
                                  FROM
                                      ss_pagecount_kyocer
                              );

        RETURN o_cursor;
    END;

    FUNCTION getPrinterStatus (
        p_make   IN       VARCHAR2,
        p_srno   IN       VARCHAR2,
        p_to     IN       VARCHAR2
    ) RETURN VARCHAR2 IS
        vsrno ss_pagecount_kyocer.srno%TYPE;
    BEGIN 
        IF p_make = 'Kyocera' THEN
            SELECT
                 srno
             INTO vsrno
             FROM
                 ss_pagecount_kyocer
             WHERE
                 srno = TRIM(p_srno)
                 AND entry_date = (
                     SELECT
                         TO_CHAR(MAX(to_number(entry_date)))
                     FROM
                         ss_pagecount_kyocer
                     WHERE
                         to_number(entry_date) <= to_number(p_to)
                            );   
        ELSIF p_make = 'Canon' THEN
            SELECT
                 srno
             INTO vsrno
             FROM
                 ss_pagecount_canon
             WHERE
                 srno = TRIM(p_srno)
                 AND entry_date = (
                     SELECT
                         TO_CHAR(MAX(to_number(entry_date)))
                     FROM
                         ss_pagecount_canon
                     WHERE
                         to_number(entry_date) <= to_number(p_to)
                            );                              
        END IF;                        
        RETURN NULL;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN 'Down';
    END;

    FUNCTION getListPrint (
        p_from VARCHAR2,
        p_to VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        o_cursor SYS_REFCURSOR;
    BEGIN
        OPEN o_cursor FOR SELECT
                              substr(a.entry_date, 1, 8) entry_date,
                              a.ipaddress,
                              'Kyocera' make,
                              a.prn_queue,
                              a.srno,
                              a.hostname,
                              a.prn_name,
                              a.prn_online,
                              a.office,
                              a.floor,
                              a.wing,
                              nvl(a.bw_a3_daily_srno, 0) + 
                              nvl(b.bw_a3_daily_srno, 0) bw_a3_daily,
                              nvl(a.bw_b4_daily_srno, 0) + 
                              nvl(b.bw_b4_daily_srno, 0) + 
                              nvl(a.bw_a4_daily_srno, 0) + 
                              nvl(b.bw_a4_daily_srno, 0) + 
                              nvl(a.bw_b5_daily_srno, 0) + 
                              nvl(b.bw_b5_daily_srno, 0) + 
                              nvl(a.bw_a5_daily_srno, 0) + 
                              nvl(b.bw_a5_daily_srno, 0) + 
                              nvl(a.bw_folio_daily_srno, 0) + 
                              nvl(b.bw_folio_daily_srno, 0) + 
                              nvl(a.bw_ledger_daily_srno, 0) + 
                              nvl(b.bw_ledger_daily_srno, 0) + 
                              nvl(a.bw_legal_daily_srno, 0) + 
                              nvl(b.bw_legal_daily_srno, 0) + 
                              nvl(a.bw_letter_daily_srno, 0) + 
                              nvl(b.bw_letter_daily_srno, 0) + 
                              nvl(a.bw_statement_daily_srno, 0) + 
                              nvl(b.bw_statement_daily_srno, 0) + 
                              nvl(a.bw_banner1_daily_srno, 0) + 
                              nvl(b.bw_banner1_daily_srno, 0) + 
                              nvl(a.bw_banner2_daily_srno, 0) + 
                              nvl(b.bw_banner2_daily_srno, 0) + 
                              nvl(a.bw_other1_daily_srno, 0) + 
                              nvl(b.bw_other1_daily_srno, 0) + 
                              nvl(a.bw_other2_daily_srno, 0) + 
                              nvl(b.bw_other2_daily_srno, 0) bw_a4_daily,
                              nvl(a.color_a3_daily_srno, 0) + 
                              nvl(b.color_a3_daily_srno, 0) color_a3_daily,
                              nvl(a.color_b4_daily_srno, 0) + 
                              nvl(b.color_b4_daily_srno, 0) + 
                              nvl(a.color_a4_daily_srno, 0) + 
                              nvl(b.color_a4_daily_srno, 0) + 
                              nvl(a.color_b5_daily_srno, 0) + 
                              nvl(b.color_b5_daily_srno, 0) + 
                              nvl(a.color_a5_daily_srno, 0) + 
                              nvl(b.color_a5_daily_srno, 0) + 
                              nvl(a.color_folio_daily_srno, 0) + 
                              nvl(b.color_folio_daily_srno, 0) + 
                              nvl(a.color_ledger_daily_srno, 0) + 
                              nvl(b.color_ledger_daily_srno, 0) +
                              nvl(a.color_legal_daily_srno, 0) + 
                              nvl(b.color_legal_daily_srno, 0) + 
                              nvl(a.color_letter_daily_srno, 0) + 
                              nvl(b.color_letter_daily_srno, 0) + 
                              nvl(a.color_statement_daily_srno, 0) + 
                              nvl(b.color_statement_daily_srno, 0) + 
                              nvl(a.color_banner1_daily_srno, 0) + 
                              nvl(b.color_banner1_daily_srno, 0) + 
                              nvl(a.color_banner2_daily_srno, 0) + 
                              nvl(b.color_banner2_daily_srno, 0) + 
                              nvl(a.color_other1_daily_srno, 0) + 
                              nvl(b.color_other1_daily_srno, 0) + 
                              nvl(a.color_other2_daily_srno, 0) + 
                              nvl(b.color_other2_daily_srno, 0) color_a4_daily
                          FROM
                              ss_pagecount_kyocer          a,
                              ss_pagecount_kyocer_manual   b
                          WHERE
                              to_number(a.entry_date) >= to_number(p_from)
                              AND to_number(a.entry_date) <= to_number(p_to)
                              AND a.manual_entry_id = b.manual_entry_id (+)
                          UNION ALL
                          SELECT
                              substr(a.entry_date, 1, 8) entry_date,
                              a.ipaddress,
                              'Canon' make,
                              a.prn_queue,
                              a.srno,
                              a.hostname,
                              a.prn_name,
                              a.prn_online,
                              a.office,
                              a.floor,
                              a.wing,
                              nvl(a.blacklarge_daily_srno, 0) + 
                              nvl(b.blacklarge_daily_srno, 0) bw_a3_daily,
                              nvl(a.blacksmall_daily_srno, 0) + 
                              nvl(b.blacksmall_daily_srno, 0) bw_a4_daily,
                              nvl(a.colorlarge_daily_srno, 0) + 
                              nvl(b.colorlarge_daily_srno, 0) color_a3_daily,
                              nvl(a.colorsmall_daily_srno, 0) + 
                              nvl(b.colorsmall_daily_srno, 0) color_a4_daily
                          FROM
                              ss_pagecount_canon          a,
                              ss_pagecount_canon_manual   b
                          WHERE
                              to_number(a.entry_date) >= to_number(p_from)
                              AND to_number(a.entry_date) <= to_number(p_to)
                              AND a.manual_entry_id = b.manual_entry_id (+)
                          ORDER BY
                              1;

        RETURN o_cursor;
    END;

    FUNCTION makeZero(p_number NUMBER) RETURN NUMBER Is 
    BEGIN
        IF p_number < 0 THEN
            RETURN 0;
        ELSE
            RETURN p_number;
        END IF;
    END;

END NETWORK_DATA_PRINTER;


/

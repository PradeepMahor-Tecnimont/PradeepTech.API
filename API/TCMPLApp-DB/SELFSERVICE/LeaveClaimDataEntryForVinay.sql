/*declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '11370',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('28-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('11370' || '-' || v_success);
end;
/*/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50017',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('22-07-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50017' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02303',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02303' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03552',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('05-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'HEALTH CHECK UP',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03552' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03123',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('11-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03123' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03045',
        p_leave_type       => 'PL',
        p_leave_period     =>5,
        p_start_date       =>to_date('18-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('22-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03045' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07020',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('14-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07020' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03011',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('11-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'FEVER',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03011' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03080',
        p_leave_type       => 'PL',
        p_leave_period     =>2,
        p_start_date       =>to_date('09-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('11-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'HEALTH',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03080' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04062',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('05-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04062' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07089',
        p_leave_type       => 'PL',
        p_leave_period     =>11,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('28-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07089' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03011',
        p_leave_type       => 'PL',
        p_leave_period     =>12,
        p_start_date       =>to_date('29-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('13-11-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03011' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07088',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('13-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07088' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '15640',
        p_leave_type       => 'PL',
        p_leave_period     =>3,
        p_start_date       =>to_date('12-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('14-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('15640' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02984',
        p_leave_type       => 'PL',
        p_leave_period     =>11,
        p_start_date       =>to_date('11-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('23-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02984' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '10429',
        p_leave_type       => 'CL',
        p_leave_period     =>1.5,
        p_start_date       =>to_date('04-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('06-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('10429' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '01903',
        p_leave_type       => 'PL',
        p_leave_period     =>13,
        p_start_date       =>to_date('08-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('23-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('01903' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '01979',
        p_leave_type       => 'PL',
        p_leave_period     =>8,
        p_start_date       =>to_date('07-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('16-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('01979' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07088',
        p_leave_type       => 'CL',
        p_leave_period     =>0.5,
        p_start_date       =>to_date('01-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07088' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07088',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('04-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07088' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02909',
        p_leave_type       => 'PL',
        p_leave_period     =>5,
        p_start_date       =>to_date('11-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('16-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02909' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50042',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('04-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('05-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50042' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03218',
        p_leave_type       => 'PL',
        p_leave_period     =>9,
        p_start_date       =>to_date('01-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('11-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'DEMOB',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03218' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07088',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('20-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('21-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07088' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50028',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('17-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50028' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03011',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('11-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03011' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03123',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('10-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03123' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '07114',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('03-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('07114' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04062',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('12-08-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'FEVER',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04062' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04335',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('22-07-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04335' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03120',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('18-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'SICK',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03120' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '01943',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('25-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('01943' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04463',
        p_leave_type       => 'PL',
        p_leave_period     =>3,
        p_start_date       =>to_date('25-08-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('27-08-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04463' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02144',
        p_leave_type       => 'SL',
        p_leave_period     =>0.5,
        p_start_date       =>to_date('31-08-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'sick',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02144' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03649',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('28-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'sick',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03649' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '01564',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('31-08-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('01564' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '11344',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('03-09-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'SICK',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('11344' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '11370',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('12-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('11370' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04470',
        p_leave_type       => 'CL',
        p_leave_period     =>0.5,
        p_start_date       =>to_date('09-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04470' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04470',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04470' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50028',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('05-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'medical',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50028' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03552',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('23-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'SICK',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03552' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50042',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'NOT FEELING WELL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50042' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50042',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('18-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50042' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02144',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('25-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'SICK',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02144' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03429',
        p_leave_type       => 'CL',
        p_leave_period     =>0.5,
        p_start_date       =>to_date('04-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03429' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50072',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('25-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('26-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50072' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03081',
        p_leave_type       => 'PL',
        p_leave_period     =>17,
        p_start_date       =>to_date('29-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('19-11-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03081' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '00583',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('13-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('14-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('00583' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '00583',
        p_leave_type       => 'PL',
        p_leave_period     =>4,
        p_start_date       =>to_date('18-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('21-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('00583' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02185',
        p_leave_type       => 'CL',
        p_leave_period     =>3,
        p_start_date       =>to_date('21-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('23-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'FAMILY SHIFTING',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02185' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04053',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('09-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04053' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04053',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('28-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04053' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02958',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02958' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03208',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('12-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('13-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03208' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02951',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02951' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '04434',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('16-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('04434' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50037',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('22-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50037' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50038',
        p_leave_type       => 'PL',
        p_leave_period     =>6.5,
        p_start_date       =>to_date('29-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('06-11-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'school admission',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50038' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50036',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('01-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50036' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50056',
        p_leave_type       => 'SL',
        p_leave_period     =>1,
        p_start_date       =>to_date('05-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'SICK',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50056' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50059',
        p_leave_type       => 'CL',
        p_leave_period     =>3,
        p_start_date       =>to_date('11-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('13-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50059' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50059',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('14-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50059' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '50062',
        p_leave_type       => 'CL',
        p_leave_period     =>2,
        p_start_date       =>to_date('23-10-2021','dd-mm-yyyy'),
        p_end_date         =>to_date('25-10-2021','dd-mm-yyyy'),
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('50062' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '02909',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('09-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('02909' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '03080',
        p_leave_type       => 'PL',
        p_leave_period     =>1,
        p_start_date       =>to_date('30-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('03080' || '-' || v_success);
end;
/
declare
        v_success varchar2(10);
        v_message varchar2(1000);
begin
    iot_leave_claims.sp_add_leave_claim(
        p_person_id        => '',
        p_meta_id          => '4592897B1381DD34EFE5', 

        p_empno            => '11605',
        p_leave_type       => 'CL',
        p_leave_period     =>1,
        p_start_date       =>to_date('30-10-2021','dd-mm-yyyy'),
        p_end_date         =>null,
        p_half_day_on      =>0,
        p_description      =>'PERSONAL',
        p_message_type          => v_success,
        p_message_text          => v_message
    ) ;
	dbms_output.put_line('11605' || '-' || v_success);
end;
/

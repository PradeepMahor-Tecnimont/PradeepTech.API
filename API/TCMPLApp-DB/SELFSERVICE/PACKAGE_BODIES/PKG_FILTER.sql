--------------------------------------------------------
--  DDL for Package Body PKG_FILTER
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."PKG_FILTER" As

    Procedure add_filter(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json     Varchar2,
        p_success Out     Varchar2,
        p_message Out     Varchar2
    ) As
    Begin
        Delete
            From app_filter
        Where
            meta_id             = p_person_id
            And module_name     = upper(p_module_name)
            And mvc_action_name = upper(p_mvc_action_name);
        Commit;
        Insert Into app_filter(meta_id, person_id, module_name, mvc_action_name, filter_json, modified_on)
        Values (meta_id, p_person_id, upper(p_module_name), upper(p_mvc_action_name), p_filter_json, sysdate);
    End add_filter;

    Procedure get_filter(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_filter_json Out Varchar2,
        p_success     Out Varchar2,
        p_message     Out Varchar2
    ) As
        rec_app_filter app_filter%rowtype;
    Begin
        Select
            *
        Into
            rec_app_filter
        From
            app_filter
        Where
            meta_id                = p_meta_id
            And module_name        = upper(p_module_name)
            And mvc_action_name    = upper(p_mvc_action_name)
            And trunc(modified_on) = trunc(sysdate);
        p_filter_json := rec_app_filter.filter_json;
        p_success     := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End get_filter;

    Procedure delete_filter(
        p_person_id       Varchar2,
        p_meta_id         Varchar2,
        p_module_name     Varchar2,
        p_mvc_action_name Varchar2,
        p_success Out     Varchar2,
        p_message Out     Varchar2
    ) As
        rec_app_filter app_filter%rowtype;
    Begin
        Delete
            From app_filter
        Where
            meta_id             = p_meta_id
            And module_name     = upper(p_module_name)
            And mvc_action_name = upper(p_mvc_action_name);

        p_success := 'OK';
    Exception
        When Others Then
            Rollback;
            p_success := 'KO';
            p_message := 'Err - ' || sqlcode || ' - ' || sqlerrm;
    End delete_filter;

End pkg_filter;

/

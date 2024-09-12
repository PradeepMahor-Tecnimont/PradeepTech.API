--------------------------------------------------------
--  DDL for Package Body SCHEMA_OBJECTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SELFSERVICE"."SCHEMA_OBJECTS" As

    Procedure grant_obj_priv As

        Cursor cur_schema_objs Is
        Select
            object_name,
            Case
                When object_type = 'TABLE'     Then
                    'SELECT,INSERT,UPDATE,DELETE'
                When object_type = 'VIEW'      Then
                    'SELECT'
                When object_type In ( 'PACKAGE',
                                      'FUNCTION',
                                      'PROCEDURE' ) Then
                    'EXECUTE'
                When object_type = 'SEQUENCE'  Then
                    'SELECT'
            End obj_priv
        From
            user_objects
        Where
            object_type In ( 'TABLE',
                             'VIEW',
                             'PACKAGE',
                             'PROCEDURE',
                             'FUNCTION',
                             'SEQUENCE' );

    Begin
        For obj In cur_schema_objs Loop
            If obj.obj_priv Is Not Null Then
                Execute Immediate 'Grant '
                                  || obj.obj_priv
                                  || ' on '
                                  || obj.object_name
                                  || ' to tcmpl_app_config';

            End If;
        End Loop;
    End grant_obj_priv;

End schema_objects;

/

  GRANT EXECUTE ON "SELFSERVICE"."SCHEMA_OBJECTS" TO "TCMPL_APP_CONFIG";

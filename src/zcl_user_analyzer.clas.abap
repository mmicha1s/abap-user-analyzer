CLASS zcl_user_analyzer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CONSTANTS:
      c_status_active TYPE string VALUE 'Active',
      c_status_locked TYPE string VALUE 'Locked'.

    TYPES: BEGIN OF ty_user_access,
             username TYPE string,
             status   TYPE string,
             last_log TYPE d,
             role     TYPE string,
           END OF ty_user_access,
           tt_user_access TYPE STANDARD TABLE OF ty_user_access WITH EMPTY KEY.

    DATA mt_user_data TYPE tt_user_access.

    METHODS fetch_mock_data.
ENDCLASS.

CLASS zcl_user_analyzer IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    fetch_mock_data( ).

    out->write( |SAP User Access Analyzer Report| ).
    out->write( |Date: { cl_abap_context_info=>get_system_date( ) DATE = ISO } | ).

    out->write( 'Full Access List (Mock Data):' ).
    out->write( mt_user_data ).

    out->write( |---------------------------------------| ).
    out->write( 'Security Alert: Locked Users' ).

    DATA lt_alerts TYPE tt_user_access.

    LOOP AT mt_user_data INTO DATA(ls_user) WHERE status = c_status_locked.
      APPEND ls_user TO lt_alerts.
    ENDLOOP.

    IF lt_alerts IS NOT INITIAL.
      out->write( lt_alerts ).
    ELSE.
      out->write( 'No security alerts found.' ).
    ENDIF.

  ENDMETHOD.

  METHOD fetch_mock_data.
    mt_user_data = VALUE #(
      ( username = 'user_1' status = c_status_active last_log = '20240410' role = 'Z_FI_MANAGER' )
      ( username = 'user_2' status = c_status_locked last_log = '20240115' role = 'Z_MM_PURCH'   )
      ( username = 'user_3' status = c_status_active last_log = '20240414' role = 'Z_SD_SALES'   )
      ( username = 'user_4' status = c_status_locked last_log = '20231120' role = 'Z_BC_ADMIN'   )
    ).
  ENDMETHOD.

ENDCLASS.

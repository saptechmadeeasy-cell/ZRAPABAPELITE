CLASS lhc_zr_rap_pk_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrRapPkTravel
        RESULT result,


      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE ZrRapPkTravel.




ENDCLASS.

CLASS lhc_zr_rap_pk_travel IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.




  METHOD earlynumbering_create.

* 1000 -- 1010
    LOOP AT entities INTO DATA(ls_entity).
      IF ls_entity-TravelID IS NOT INITIAL.
        ls_entity-%key-TravelID = ls_entity-TravelID.
        ls_entity-%key-travel_uuid = ls_entity-travel_uuid.
        APPEND VALUE #(  %cid = ls_entity-%cid
                         %is_draft = ls_entity-%is_draft
                         %key = ls_entity-%key ) TO mapped-zrrappktravel.


      ELSE.

        TRY.
            "" with the help of number range object
            cl_numberrange_runtime=>number_get(
              EXPORTING
*      ignore_buffer     =
                nr_range_nr       = '01'
                object            = '/DMO/TRV_M'
                quantity          = 1
*      subobject         =
*      toyear            =
              IMPORTING
                number            = DATA(lv_next_avail_number) "1005
                returncode        = DATA(lv_rc)
                returned_quantity = DATA(lv_rq)
            ).
          CATCH cx_nr_object_not_found.
          CATCH cx_number_ranges.

        ENDTRY.

        ls_entity-%key-TravelID = lv_next_avail_number.
        TRY.
        ls_entity-%key-travel_uuid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH CX_UUID_ERROR .

        ENDTRY.
        APPEND VALUE #(  %cid = ls_entity-%cid
                         %is_draft = ls_entity-%is_draft
                         %key = ls_entity-%key ) TO mapped-zrrappktravel.



      ENDIF.


        ""direct from db table
*    "SELECT THE HIGHEST NUMBER FROM ACTIVE DB
*    SELECT MAX( travel_id ) FROM zrap_pk_travel INTO @DATA(lv_active_max).
*
*    "SELECT THE HIGHEST FROM DRAFT TABLE
*    SELECT MAX( travelid ) FROM zrap_pk_travel_d INTO @DATA(lv_draft_max).
*
*    IF lv_active_max > lv_draft_max.
*      "IDENTIFY THE HIGHEST OCCUPIED NUMBER
*
*      DATA(lv_honum) = lv_active_max.
*
*    ELSE.
*
*      lv_honum = lv_draft_max.
*
*
*    ENDIF.
*
*    "SET THE PRIMARY KEY
*
*    DATA(lv_pk) = CONV int2( lv_honum + 1 ).
*
*    LOOP AT entities INTO DATA(ls_entity).
*    ls_entity-%key-TravelID = lv_pk.
*      APPEND VALUE #(  %cid = ls_entity-%cid
*                       %is_draft = ls_entity-%is_draft
*                       %key = ls_entity-%key ) TO mapped-zrrappktravel.
*
*    ENDLOOP.


    ENDLOOP.







  ENDMETHOD.

ENDCLASS.

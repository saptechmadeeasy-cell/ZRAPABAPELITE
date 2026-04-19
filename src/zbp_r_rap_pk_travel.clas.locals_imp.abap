CLASS lsc_zr_rap_pk_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_rap_pk_travel IMPLEMENTATION.

  METHOD save_modified.
    DATA: lt_travel_data TYPE TABLE OF zrap_pk_travel.
    DATA: ls_travel_data LIKE LINE OF lt_travel_data .

    "
    IF create-zr_rap_pk_travel IS NOT INITIAL.

      lt_travel_data = CORRESPONDING #(  create-zr_rap_pk_travel MAPPING FROM ENTITY  ).

      MODIFY zrap_pk_travel FROM TABLE @lt_travel_data.


    ENDIF.




    IF update-zr_rap_pk_travel IS NOT INITIAL.

      SELECT * FROM zrap_pk_travel INTO TABLE @DATA(lt_orig_data).

      " Note: Replace 'your_table_type' with the actual table type (e.g., tt_travel)
      lt_travel_data = VALUE #(
        FOR ls_upd_new IN update-zr_rap_pk_travel
        LET ls_old = VALUE #( lt_orig_data[ travel_id = ls_upd_new-TravelID ] OPTIONAL )
        IN ( " <-- Correction 1: Removed VALUE #(
          client      = sy-mandt
          travel_id   = ls_upd_new-TravelID
          travel_uuid = ls_upd_new-Travel_UUID

          agency_id = COND #(
            WHEN ls_upd_new-%control-agencyid = if_abap_behv=>mk-on
            THEN ls_upd_new-agencyid
            ELSE ls_old-agency_id )

          customer_id = COND #(
            WHEN ls_upd_new-%control-customerid = if_abap_behv=>mk-on
            THEN ls_upd_new-customerid
            ELSE ls_old-customer_id )

          begin_date = COND #(
            WHEN ls_upd_new-%control-begindate = if_abap_behv=>mk-on
            THEN ls_upd_new-begindate
            ELSE ls_old-begin_date )

          end_date = COND #(
            WHEN ls_upd_new-%control-enddate = if_abap_behv=>mk-on
            THEN ls_upd_new-enddate
            ELSE ls_old-end_date )

          booking_fee = COND #(
            WHEN ls_upd_new-%control-bookingfee = if_abap_behv=>mk-on
            THEN ls_upd_new-bookingfee
            ELSE ls_old-booking_fee )

          total_price = COND #(
            WHEN ls_upd_new-%control-totalprice = if_abap_behv=>mk-on
            THEN ls_upd_new-totalprice
            ELSE ls_old-total_price )

          currency_code = COND #(
            WHEN ls_upd_new-%control-currencycode = if_abap_behv=>mk-on
            THEN ls_upd_new-currencycode
            ELSE ls_old-currency_code )

          description = COND #(
            WHEN ls_upd_new-%control-description = if_abap_behv=>mk-on
            THEN ls_upd_new-description
            ELSE ls_old-description )

          overall_status = COND #(
            WHEN ls_upd_new-%control-overallstatus = if_abap_behv=>mk-on
            THEN ls_upd_new-overallstatus
            ELSE ls_old-overall_status )

          attachment = COND #(
            WHEN ls_upd_new-%control-attachment = if_abap_behv=>mk-on
            THEN ls_upd_new-attachment
            ELSE ls_old-attachment )

          mime_type = COND #(
            WHEN ls_upd_new-%control-mimetype = if_abap_behv=>mk-on
            THEN ls_upd_new-mimetype
            ELSE ls_old-mime_type )

          file_name = COND #(
            WHEN ls_upd_new-%control-filename = if_abap_behv=>mk-on
            THEN ls_upd_new-filename
            ELSE ls_old-file_name )

          local_last_changed_by = sy-uname
          local_last_changed_at = cl_abap_context_info=>get_system_time( )
        )
      ).
      MODIFY zrap_pk_travel FROM TABLE @lt_travel_data.

    ENDIF.



    IF delete-zr_rap_pk_travel IS NOT INITIAL.

      lt_travel_data = CORRESPONDING #(  delete-zr_rap_pk_travel MAPPING FROM ENTITY  ).

      DELETE zrap_pk_travel FROM TABLE @lt_travel_data.


    ENDIF.

  ENDMETHOD.

ENDCLASS.



*CLASS lsc_zr_rap_pk_travel DEFINITION INHERITING FROM cl_abap_behavior_saver.
*
*  PUBLIC SECTION.
*
*    "DEFINE REQUIRED STRUCTURE AND TABEL TYPES AND VARIABLES
*    TYPES: BEGIN OF ts_log,
*             travel_id  TYPE /dmo/travel_id,
*             field_name TYPE c LENGTH 20,
*             old_val    TYPE c LENGTH 20,
*             new_val    TYPE c LENGTH 20,
*           END OF ts_log.
*
*    "TABLE TYPES
*
*    TYPES: tt_create TYPE TABLE FOR CHANGE zr_rap_pk_travel.
*
*    TYPES: tt_log TYPE TABLE OF ts_log.
*
*    METHODS: get_log IMPORTING it_data    TYPE tt_create
*                     EXPORTING et_log     TYPE tt_log.
**                               et_counter TYPE int1.
*
*
*
*
*  PROTECTED SECTION.
*
*    METHODS save_modified REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_zr_rap_pk_travel IMPLEMENTATION.
*
*  METHOD save_modified.
*    DATA: lt_db_insert TYPE TABLE OF zdmo_log_save.
*
*    GET TIME STAMP FIELD DATA(lv_ts).
*
*    "capture the change log for our travel record
*    IF create-zr_rap_pk_travel IS NOT INITIAL.
*      get_log(
*          EXPORTING
*            it_data    = create-zr_rap_pk_travel
*          IMPORTING
*            et_log     = DATA(lt_create_log)
**            et_counter = DATA(lv_cr_counter)
*        ).
*    "CREATING FRESH RECORD
*    LOOP AT create-zr_rap_pk_travel INTO DATA(ls_create).
*
*      LOOP AT lt_create_log INTO DATA(ls_log_cr).
*
*        TRY.
*
*            APPEND VALUE #( client = sy-mandt
*                            log_uuid = cl_system_uuid=>create_uuid_x16_static( )
*                            travel_uuid = ls_create-travel_uuid
*                            travel_id = ls_create-TravelID
*                             operation   = 'CREATE'
*                              changed_by  = sy-uname
*                              changed_at  = lv_ts
*                              field_name  = ls_log_cr-field_name
*                              old_value   = ls_log_cr-old_val
*                              new_value   = ls_log_cr-new_val ) TO lt_db_insert .
*          CATCH   cx_uuid_error .
*        ENDTRY.
*      ENDLOOP..
*      MODIFY zdmo_log_save FROM TABLE @lt_db_insert.
*    ENDLOOP.
* ENDIF.
*
*
* if update-zr_rap_pk_travel is not inITIAL.
*     get_log(
*          EXPORTING
*            it_data    = UPDATE-zr_rap_pk_travel
*          IMPORTING
*            et_log     = lt_create_log
*        ).
*
*
*     LOOP AT update-zr_rap_pk_travel INTO ls_create.
*
*      LOOP AT lt_create_log INTO ls_log_cr.
*
*        TRY.
*
*            APPEND VALUE #( client = sy-mandt
*                            log_uuid = cl_system_uuid=>create_uuid_x16_static( )
*                            travel_uuid = ls_create-travel_uuid
*                            travel_id = ls_create-TravelID
*                             operation   = 'UPDATE'
*                              changed_by  = sy-uname
*                              changed_at  = lv_ts
*                              field_name  = ls_log_cr-field_name
*                              old_value   = ls_log_cr-old_val
*                              new_value   = ls_log_cr-new_val ) TO lt_db_insert .
*          CATCH   cx_uuid_error .
*        ENDTRY.
*      ENDLOOP..
*      MODIFY zdmo_log_save FROM TABLE @lt_db_insert.
*    ENDLOOP.
*
* endif.
*
*IF DELETE-zr_rap_pk_travel IS NOT INITIAL.
*
*DELETE FROM zdmo_log_save.
*  LOOP AT delete-zr_rap_pk_travel INTO DATA(ls_delete).
*        TRY.
*            APPEND VALUE #( client      = sy-mandt
*                            log_uuid    = cl_system_uuid=>create_uuid_x16_static( )
*                             travel_id   = ls_delete-travelId
*                            operation   = 'DELETE'
*                            changed_by  = sy-uname
*                            changed_at  = lv_ts
*                            field_name  = 'ENTIRE_RECORD'
*                            old_value   = 'DELETED'
*                            new_value   = space ) TO lt_db_insert.
*          CATCH cx_uuid_error.
*        ENDTRY.
*      ENDLOOP.
*
*MODIFY zdmo_log_save FROM TABLE @lt_db_insert.
*
*ENDIF.
*
*
*
*
*
*  ENDMETHOD.
*
*  METHOD get_log.
*
*    DATA: ls_log TYPE ts_log.
*    CLEAR et_log.
*
*    " Retained explicitly for Demo Purposes to show clean entries to students
*    DELETE FROM zdmo_log_save.
*
*    " Fetch original data once to avoid SELECT queries inside the LOOP
*    SELECT * FROM zrap_pk_travel FOR ALL ENTRIES IN @it_data
*      WHERE travel_id = @it_data-travelid INTO TABLE @DATA(lt_orig_data).
*
*    LOOP AT it_data INTO DATA(wa).
*      CLEAR ls_log.
*
*      IF wa-%control-AgencyId = if_abap_behv=>mk-on.
*        ls_log-travel_id  = wa-travelId.
*        ls_log-field_name = 'Agency Id'.
*        ls_log-old_val    = VALUE #( lt_orig_data[ travel_id = wa-travelId ]-agency_id OPTIONAL ).
*        ls_log-new_val    = wa-AgencyId.
*        APPEND ls_log TO et_log. CLEAR ls_log.
*      ENDIF.
*
*
*      IF wa-%control-CustomerID = if_abap_behv=>mk-on.
*        ls_log-travel_id  = wa-travelId.
*        ls_log-field_name = 'CustomerID'.
*        ls_log-old_val    = VALUE #( lt_orig_data[ travel_id = wa-travelId ]-customer_id OPTIONAL ).
*        ls_log-new_val    = wa-CustomerID.
*        APPEND ls_log TO et_log. CLEAR ls_log.
*      ENDIF.
*
*
*      IF wa-%control-BookingFee = if_abap_behv=>mk-on.
*        ls_log-travel_id  = wa-TravelID.
*        ls_log-field_name = 'BookingFee'.
*        ls_log-old_val    = VALUE #( lt_orig_data[ travel_id = wa-travelId ]-booking_fee OPTIONAL ).
*        ls_log-new_val    = wa-BookingFee.
*        APPEND ls_log TO et_log. CLEAR ls_log.
*      ENDIF.
*
*
*         IF wa-%control-TotalPrice = if_abap_behv=>mk-on.
*        ls_log-travel_id  = wa-TravelID.
*        ls_log-field_name = 'TOTALPRICE'.
*        ls_log-old_val    = VALUE #( lt_orig_data[ travel_id = wa-travelId ]-total_price OPTIONAL ).
*        ls_log-new_val    = wa-TotalPrice.
*        APPEND ls_log TO et_log. CLEAR ls_log.
*      ENDIF.
*
*
*
*
*      IF wa-%control-Description = if_abap_behv=>mk-on.
*        ls_log-travel_id  = wa-travelId.
*        ls_log-field_name = 'Description'.
*        ls_log-old_val    = VALUE #( lt_orig_data[ travel_id = wa-travelId ]-description OPTIONAL ).
*        ls_log-new_val    = wa-Description.
*        APPEND ls_log TO et_log. CLEAR ls_log.
*      ENDIF.
*
*    ENDLOOP.
*
*
*  ENDMETHOD.
*
*ENDCLASS.

CLASS lhc_zr_rap_pk_travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF travel_status,
        open     TYPE c LENGTH 1 VALUE 'O', "Open
        accepted TYPE c LENGTH 1 VALUE 'A', "Accepted
        rejected TYPE c LENGTH 1 VALUE 'X', "Rejected
      END OF travel_status.

    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zr_rap_pk_travel
        RESULT result,


      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE zr_rap_pk_travel,
      determinedefaultstatus FOR DETERMINE ON MODIFY
        IMPORTING keys FOR zr_rap_pk_travel~determinedefaultstatus,
      validatecustomer FOR VALIDATE ON SAVE
        IMPORTING keys FOR zr_rap_pk_travel~validatecustomer,
      applydiscount FOR MODIFY
        IMPORTING keys FOR ACTION zr_rap_pk_travel~applydiscount RESULT result,
      applydiscountwithp FOR MODIFY
        IMPORTING keys FOR ACTION zr_rap_pk_travel~applydiscountwithp RESULT result,
      copyandcreate FOR MODIFY
        IMPORTING keys FOR ACTION zr_rap_pk_travel~copyandcreate,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR zr_rap_pk_travel RESULT result,
      getdiscountedprice FOR READ
        IMPORTING keys FOR FUNCTION zr_rap_pk_travel~getdiscountedprice RESULT result,
      calculateaverageprice FOR READ
        IMPORTING keys FOR FUNCTION zr_rap_pk_travel~calculateaverageprice RESULT result.

*          METHODS checktravelvalidity FOR READ
*            IMPORTING keys FOR FUNCTION zr_rap_pk_travel~checktravelvalidity RESULT result.
*      get_instance_features FOR INSTANCE FEATURES
*        IMPORTING keys REQUEST requested_features FOR zr_rap_pk_travel RESULT result.

*      getdiscountedprice FOR READ
*        IMPORTING keys FOR FUNCTION zr_rap_pk_travel~getdiscountedprice RESULT result,
*              getdiscountedprice2 FOR READ
*        IMPORTING keys FOR FUNCTION zr_rap_pk_travel~getdiscountedprice2 RESULT result.
*      validatecustomer FOR VALIDATE ON SAVE
*            IMPORTING keys FOR zr_rap_pk_travel~validatecustomer.




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
                         %key = ls_entity-%key ) TO mapped-zr_rap_pk_travel.


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
          CATCH cx_uuid_error .

        ENDTRY.
        APPEND VALUE #(  %cid = ls_entity-%cid
                         %is_draft = ls_entity-%is_draft
                         %key = ls_entity-%key ) TO mapped-zr_rap_pk_travel.



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

  METHOD determineDefaultStatus.



    "EML

    READ ENTITIES OF zr_rap_pk_travel
     IN LOCAL MODE "skipping authorization and feature control
     ENTITY zr_rap_pk_travel
     FIELDS ( OverallStatus )
     WITH CORRESPONDING  #( keys )
     RESULT DATA(lt_result)
     FAILED DATA(lt_failed).


*   "If overall travel status is already set, do nothing, i.e. remove such instances
*    DELETE travels WHERE OverallStatus IS NOT INITIAL.
*    CHECK travels IS NOT INITIAL.
*
*    "else set overall travel status to open ('O')
*    MODIFY ENTITIES OF ZR_TRAVEL_M_PK IN LOCAL MODE
*      ENTITY zrtravelmpk
*        UPDATE SET FIELDS
*        WITH VALUE #( FOR travel IN travels ( %tky    = travel-%tky
*                                              OverallStatus = travel_status-open ) )
*    REPORTED DATA(update_reported).
*
*    "Set the changing parameter
*    reported = CORRESPONDING #( DEEP update_reported ).







    LOOP AT lt_result INTO DATA(ls_result).
      IF ls_result-OverallStatus IS INITIAL.

        "else set overall travel status to open ('O')
        MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE
          ENTITY zr_rap_pk_travel
            UPDATE SET FIELDS
            WITH VALUE #( ( %tky    = ls_result-%tky
                                                  OverallStatus = travel_status-open ) )
        REPORTED DATA(update_reported).


      ENDIF.

    ENDLOOP.


  ENDMETHOD.

*  METHOD ValidateCustomer.

*  ********************************************************************
* Validation: Check the validity of the entered customer data
**********************************************************************

*      "read relevant travel instance data
*      READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE
*      ENTITY zr_rap_pk_travel
*       FIELDS ( CustomerID )
*       WITH CORRESPONDING #( keys )
*      RESULT DATA(travels).
*
*      DATA lt_customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
*
*      "optimization of DB select: extract distinct non-initial customer IDs
*      lt_customers = CORRESPONDING #( travels DISCARDING DUPLICATES MAPPING customer_id = customerID EXCEPT * ).
*      DELETE lt_customers WHERE customer_id IS INITIAL.
*
*      IF lt_customers IS NOT INITIAL.
*
*        "check if customer ID exists
*        SELECT FROM /dmo/customer FIELDS customer_id
*                                  FOR ALL ENTRIES IN @lt_customers
*                                  WHERE customer_id = @lt_customers-customer_id
*          INTO TABLE @DATA(valid_customers).
*      ENDIF.
*
*      "raise msg for non existing and initial customer id
*      LOOP AT travels INTO DATA(travel).
*
*
*
*
*"if some error message is present in draft mode then it'll delete that
*        APPEND VALUE #(  %tky                 = travel-%tky
*                         %state_area          = 'VALIDATE_CUSTOMER'
*                       ) TO reported-zr_rap_pk_travel.
*
*
*
*
*        IF travel-CustomerID IS  INITIAL.
*          APPEND VALUE #( %tky = travel-%tky ) TO failed-zr_rap_pk_travel. "interview questions
*
*          APPEND VALUE #( %tky                = travel-%tky
*                          %state_area         = 'VALIDATE_CUSTOMER' "persist message in draft status
*                          %msg                = NEW /dmo/cm_flight_messages(
*                                                                  textid   = /dmo/cm_flight_messages=>enter_customer_id
*                                                                  severity = if_abap_behv_message=>severity-error )
*
*
*                          %element-CustomerID = if_abap_behv=>mk-on "highlight the field
*
*
*
*                        ) TO reported-zr_rap_pk_travel.
*
*        ELSEIF travel-CustomerID IS NOT INITIAL AND NOT line_exists( valid_customers[ customer_id = travel-CustomerID ] ).
*          APPEND VALUE #(  %tky = travel-%tky ) TO failed-zr_rap_pk_travel.
*
*          APPEND VALUE #(  %tky                = travel-%tky
*                           %state_area         = 'VALIDATE_CUSTOMER'
*                           %msg                = NEW /dmo/cm_flight_messages(
*                                                                  customer_id = travel-customerid
*                                                                  textid      = /dmo/cm_flight_messages=>customer_unkown
*                                                                  severity    = if_abap_behv_message=>severity-error )
*                           %element-CustomerID = if_abap_behv=>mk-on
*
*
*                        ) TO reported-zr_rap_pk_travel.
*        ENDIF.
*
*      ENDLOOP.
*

*  ENDMETHOD.

  METHOD ValidateCustomer.

    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE

    ENTITY zr_rap_pk_travel
    FIELDS (  CustomerID )

           WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel_ins).

    IF lt_travel_ins  IS NOT INITIAL.
      DATA(ls_travel) = lt_travel_ins[ 1 ] .

      APPEND VALUE #( %tky                = ls_travel-%tky
                 %state_area         = 'VALIDATE_CUSTOMER' "DELETING/FLUSHING THE MESSAGE FROM %STATE_AREA

               ) TO reported-zr_rap_pk_travel.

      "IF CUSTOMER IS BLANK THEN DISPLAY ERROR MESSAG -- 'ENTER CUSTOMER ID'
      IF lt_travel_ins[ 1 ]-CustomerID IS INITIAL.





        APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-zr_rap_pk_travel. "interview questions

        APPEND VALUE #(        %tky                = ls_travel-%tky
                               %state_area         = 'VALIDATE_CUSTOMER' "persist message in draft status
                               %msg                = NEW /dmo/cm_flight_messages(
                               textid   = /dmo/cm_flight_messages=>enter_customer_id
                               severity = if_abap_behv_message=>severity-error )
                               %element-CustomerID = if_abap_behv=>mk-on "highlight the field
                             ) TO reported-zr_rap_pk_travel.


      ELSE.

        DATA lt_customers TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
*      "optimization of DB select: extract distinct non-initial customer IDs
        lt_customers = CORRESPONDING #( lt_travel_ins  MAPPING customer_id = customerID EXCEPT * ).
*      DELETE lt_customers WHERE customer_id IS INITIAL.
*
        IF lt_customers IS NOT INITIAL.

*        "check if customer ID exists
          SELECT FROM /dmo/customer FIELDS customer_id
                                    FOR ALL ENTRIES IN @lt_customers
                                    WHERE customer_id = @lt_customers-customer_id
            INTO TABLE @DATA(valid_customers).
        ENDIF.

        ls_travel = lt_travel_ins[ 1 ] .
        IF NOT line_exists( valid_customers[ customer_id = ls_travel-CustomerID ] ).

          APPEND VALUE #( %tky = ls_travel-%tky ) TO failed-zr_rap_pk_travel. "interview questions


          APPEND VALUE #(  %tky                = ls_travel-%tky
                           %state_area         = 'VALIDATE_CUSTOMER'
                           %msg                = NEW /dmo/cm_flight_messages(
                                                                  customer_id = ls_travel-customerid
                                                                  textid      = /dmo/cm_flight_messages=>customer_unkown
                                                                  severity    = if_abap_behv_message=>severity-error )
                           %element-CustomerID = if_abap_behv=>mk-on


                        ) TO reported-zr_rap_pk_travel.


        ENDIF.



      ENDIF.



    ENDIF.




  ENDMETHOD.

  METHOD applyDiscount.


    "define one internal table to upudate the data of the instance
    DATA:lt_update TYPE TABLE FOR UPDATE zr_rap_pk_travel.


    DATA(lt_travel_with_discount) = keys.

    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    FIELDS ( BookingFee ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_bf).



    LOOP AT lt_travel_bf INTO DATA(ls).
      APPEND VALUE #(
                  %tky = ls-%tky
                   BookingFee = ( ls-BookingFee ) *  '0.7'
                   ) TO lt_update.
    ENDLOOP.


    MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY

    zr_rap_pk_travel UPDATE FIELDS ( BookingFee ) WITH lt_update

     FAILED DATA(lt_failed).


    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    ALL FIELDS WITH CORRESPONDING #( keys  ) RESULT DATA(lt_updated_data).

    result = VALUE #(  FOR wa IN lt_updated_data ( %tky = wa-%tky %param = wa )  ).




  ENDMETHOD.

  METHOD applyDiscountwithp.


    "define one internal table to upudate the data of the instance
    DATA:lt_update TYPE TABLE FOR UPDATE zr_rap_pk_travel.


    DATA(lt_travel_with_discount) = keys.

    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    FIELDS ( BookingFee ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel_bf).


    IF keys IS INITIAL.
      RETURN.

    ELSE.

      DATA(lv_discount) = keys[ 1 ]-%param-discount_percent.

      IF lv_discount   LE 100 AND lv_discount > 0.
      ELSE.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky )  TO failed-zr_rap_pk_travel.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
            %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
                text = 'give valid discount value'
                                        ) ) TO reported-zr_rap_pk_travel.

      ENDIF.

    ENDIF.

    LOOP AT lt_travel_bf INTO DATA(ls).
      APPEND VALUE #(
                  %tky = ls-%tky
*                   BookingFee = ( ls-BookingFee ) *  '0.7'

      BookingFee = ( ls-bookingfee ) * ( (  100 - ( keys[ 1 ]-%param-discount_percent  ) ) / 100 )
                   ) TO lt_update.
    ENDLOOP.


    MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY

    zr_rap_pk_travel UPDATE FIELDS ( BookingFee ) WITH lt_update

     FAILED DATA(lt_failed).


    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    ALL FIELDS WITH CORRESPONDING #( keys  ) RESULT DATA(lt_updated_data).

    result = VALUE #(  FOR wa IN lt_updated_data ( %tky = wa-%tky %param = wa )  ).



  ENDMETHOD.

  METHOD copyAndCreate.
    "Create one internal table of type crate
    DATA: lt_new_travel TYPE TABLE FOR CREATE zr_rap_pk_travel.


    "READ THE ENTIRE DATA CORRESPONDING TO THE SELECTED RECORD

    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_existing_ref).


    LOOP AT lt_existing_ref ASSIGNING FIELD-SYMBOL(<fs>).

      APPEND VALUE #(  %cid = keys[ 1 ]-%cid
                       %is_draft = keys[ KEY entity COMPONENTS %key = <fs>-%key ]-%is_draft
                       %data = CORRESPONDING #( <fs>  EXCEPT travelid ) )

                     TO   lt_new_travel
                       .

    ENDLOOP.


    "create new instance

    IF lt_new_travel IS NOT INITIAL.
      MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
      CREATE FIELDS ( AgencyID CustomerID BookingFee TotalPrice BeginDate EndDate FileName Description  )
      WITH lt_new_travel MAPPED DATA(lt_mapped_create).


      mapped-zr_rap_pk_travel  = lt_mapped_create-zr_rap_pk_travel.

    ENDIF.

  ENDMETHOD.

*  METHOD get_instance_features.
*
*
*    "REad the travel data first
*    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE  ENTITY zr_rap_pk_travel
*    ALL FIELDS WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_travel) FAILED DATA(lt_failed).
*
*    IF lt_travel IS NOT INITIAL.
*
*      result = VALUE #( FOR ls_travel IN lt_travel
*       (
*
*       "pass tkey
*
*         %tky  = ls_travel-%tky
*
*         "enable or disable UPDATE operation based on travel status
*         %features-%update = COND #(  WHEN ls_travel-OverallStatus = travel_status-accepted
*                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
*
*        "enable or disable DELETE operation based on travel status
*         %features-%delete = COND #(  WHEN ls_travel-OverallStatus = travel_status-accepted
*                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
*
*        "enable or disable UPDATE operation based on travel status
*         %action-applyDiscount =   COND #(  WHEN ls_travel-OverallStatus = travel_status-accepted
*                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
*
*        "enable or disable UPDATE operation based on travel status
*         %action-applyDiscountwithp =   COND #(  WHEN ls_travel-OverallStatus = travel_status-accepted
*                                      THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
*         )
*
*       ).
*
*    ENDIF.
*  ENDMETHOD.
*

*  METHOD CheckTravelValidity.
*    " 1. Read the travel data
*    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE
*      ENTITY zr_rap_pk_travel
*        FIELDS ( BeginDate EndDate )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_travel_data).
*
*    LOOP AT lt_travel_data ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      " 2. Check Logic
*      IF <ls_travel>-BeginDate > <ls_travel>-EndDate.
*        " Logic for invalid dates
*        APPEND VALUE #( %tky = <ls_travel>-%tky %param = <ls_travel> ) TO result.
*      ELSE.
*        " Logic for valid dates
*        APPEND VALUE #( %tky = <ls_travel>-%tky %param = <ls_travel> ) TO result.
*      ENDIF.
*    ENDLOOP.
*  ENDMETHOD.


*  METHOD GetDiscountedPrice2.
** In Local Types of the Behavior Pool Class */
*    DATA: lt_update TYPE TABLE FOR UPDATE   zr_rap_pk_travel.
*
*    " 1. Read current price and currency for the requested Travel IDs
*    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE
*      ENTITY zr_rap_pk_travel
*        FIELDS ( TotalPrice CurrencyCode )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_travel).
*
*
*    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      " 2. Get the input parameter (the discount %)
*      DATA(lv_percentage) = keys[ KEY entity %tky = <ls_travel>-%tky ]-%param-discount_percent.
*
*      " 3. Perform the calculation (Read-Only)
*      <ls_travel>-TotalPrice = <ls_travel>-TotalPrice * ( 1 - ( lv_percentage / 100 ) ).
*
*      " 4. Fill the result structure
*      APPEND VALUE #( %tky   = <ls_travel>-%tky
*                      %param = value #( TravelID   = <ls_travel>-TravelID
*                                        TotalPrice = <ls_travel>-TotalPrice
*                                        Currency   = <ls_travel>-CurrencyCode  ) )
*                                        TO result.
*
*      " 5. Fill REPORTED (This is how the user sees the message!)
*      APPEND VALUE #( %tky = <ls_travel>-%tky
*                      %msg = new_message_with_text(
*                               severity = if_abap_behv_message=>severity-information
*                               text     = |{ lv_percentage }% discount would be { <ls_travel>-TotalPrice }|
*                             ) ) TO reported-zr_rap_pk_travel.
**      APPEND VALUE #(
**                  %tky = <ls_travel>-%tky
**      TotalPrice = <ls_travel>-TotalPrice
**                   ) TO lt_update.
*    ENDLOOP.
**    MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY
**                    zr_rap_pk_travel UPDATE FIELDS ( TotalPrice ) WITH lt_update
**                    FAILED DATA(lt_failed).
*  ENDMETHOD.
*
*
*
*  METHOD GetDiscountedPrice.
** In Local Types of the Behavior Pool Class */
*    DATA: lt_update TYPE TABLE FOR UPDATE   zr_rap_pk_travel.
*
*    " 1. Read current price and currency for the requested Travel IDs
*    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE
*      ENTITY zr_rap_pk_travel
*        FIELDS ( TotalPrice CurrencyCode )
*        WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_travel).
*
*
*    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
*      " 2. Get the input parameter (the discount %)
*      DATA(lv_percentage) = keys[ KEY entity %tky = <ls_travel>-%tky ]-%param-discount_percent.
*
*      " 3. Perform the calculation (Read-Only)
*      <ls_travel>-TotalPrice = <ls_travel>-TotalPrice * ( 1 - ( lv_percentage / 100 ) ).
*
*      " 4. Fill the result structure
*      APPEND VALUE #(  %tky   = <ls_travel>-%tky
*                       %param = <ls_travel> )
*                     TO result.
*
*      " 5. Fill REPORTED (This is how the user sees the message!)
*      APPEND VALUE #( %tky = <ls_travel>-%tky
*                      %msg = new_message_with_text(
*                               severity = if_abap_behv_message=>severity-information
*                               text     = |{ lv_percentage }% discount would be { <ls_travel>-TotalPrice }|
*                             ) ) TO reported-zr_rap_pk_travel.
*
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD get_instance_features.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*  READ THE STATUS IF TRAVEL IS OPEN OR ACCEPTED
    "READ EML
    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
    FIELDS ( OverallStatus ) WITH CORRESPONDING  #( keys )
    RESULT DATA(lt_status)
    FAILED DATA(lt_data).

    IF lt_status IS NOT INITIAL.

      result = VALUE #( FOR wa IN lt_status

                              (  %tky  = wa-%tky

                                 %update = COND #(  WHEN wa-OverallStatus = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )


                                  %features-%action-Edit =   COND #(  WHEN wa-OverallStatus = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )

*    %action-Edit =   COND #(  WHEN wa-OverallStatus = 'A'
*                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )

                                %delete =  COND #(  WHEN wa-OverallStatus = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )


                                %action-applyDiscount = COND #(  WHEN wa-OverallStatus = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )


                               %action-applyDiscountwithp = COND #(  WHEN wa-OverallStatus = 'A'
                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )

                               %field-CustomerID = COND #(  WHEN wa-OverallStatus = 'B'
                                                              THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )

*                               %action-GetDiscountedPrice = COND #(  WHEN wa-OverallStatus = 'A'
*                                                              THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )



                              ) ).


    ENDIF.





  ENDMETHOD.

*  METHOD CheckTravelValidity.
*  ENDMETHOD.

  METHOD GetDiscountedPrice.
    "1 read curernt price for the travel id

    DATA: ls_param TYPE zabs_ent_result.

    READ ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY zr_rap_pk_travel
                  FIELDS ( TotalPrice  ) WITH CORRESPONDING #(  keys )
                  RESULT DATA(lt_travel).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<fs_travel>).

      DATA(lv_percentage) = keys[ %tky = <fs_travel>-%tky ]-%param-discount_percent.

      <fs_travel>-TotalPrice = <fs_travel>-TotalPrice * (  1 -  ( lv_percentage ) / 100 ).

      ls_param-travel_id = <fs_travel>-TravelID.
      ls_param-totalprice = <fs_travel>-TotalPrice.
      ls_param-currency_code = <fs_travel>-CurrencyCode.

      APPEND VALUE #( %tky = <fs_travel>-%tky

                      %param = ls_param     )

                      TO result.


*     MODIFY LT_TRAVEL FROM WA_TRAVEL.

      APPEND VALUE #( %tky  = <fs_travel>-%tky

                      %msg = new_message_with_text( severity = if_abap_behv_message=>severity-information

                                                    text = |Discounted price will be: { <fs_travel>-TotalPrice }|

                      )


                      ) TO reported-zr_rap_pk_travel.




*      DATA: lt_update TYPE TABLE FOR UPDATE zr_rap_pk_travel\\zr_rap_pk_travel .

*      LOOP AT lt_travel INTO DATA(ls).
*        APPEND VALUE #(
*                    %tky = ls-%tky
**                   BookingFee = ( ls-BookingFee ) *  '0.7'
*
*        BookingFee = ( ls-bookingfee ) * ( (  100 - ( keys[ 1 ]-%param-discount_percent  ) ) / 100 )
*                     ) TO lt_update.
*      ENDLOOP.


*      MODIFY ENTITIES OF zr_rap_pk_travel IN LOCAL MODE ENTITY
*
*      zr_rap_pk_travel UPDATE FIELDS ( BookingFee ) WITH lt_update
*
*       FAILED DATA(lt_failed).


    ENDLOOP.


  ENDMETHOD.

  METHOD CalculateAveragePrice. "average total price

    "we need to get all the travel price

    SELECT AVG( total_price )   FROM zrap_pk_travel INTO @DATA(lv_avg_price).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).

*       APPEND VALUE #( %cid = <LS_KEY>-%cid
*                        %param = value #( totalprice = lv_avg_price )  ) to result.

      APPEND VALUE #(
 %cid = <ls_key>-%cid
 %tky = VALUE #(  )  "empty for static function
                 %msg = new_message_with_text(  severity = if_abap_behv_message=>severity-information
                                                text = |average total price: { lv_avg_price } |

                 )

 ) TO reported-zr_rap_pk_travel.


    ENDLOOP.







  ENDMETHOD.

ENDCLASS.

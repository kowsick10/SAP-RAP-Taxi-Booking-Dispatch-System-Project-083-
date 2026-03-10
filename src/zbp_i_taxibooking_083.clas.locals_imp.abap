CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS setInitialStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setInitialStatus.

    METHODS assignDriver FOR MODIFY
      IMPORTING keys FOR ACTION Booking~assignDriver RESULT result.

    METHODS startTrip FOR MODIFY
      IMPORTING keys FOR ACTION Booking~startTrip RESULT result.

    METHODS completeTrip FOR MODIFY
      IMPORTING keys FOR ACTION Booking~completeTrip RESULT result.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD get_instance_features.
    " 1. Read current status of the records
    READ ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking
        FIELDS ( Status ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    " 2. Dynamic Control logic (Buttons & Read-Only Fields)
    result = VALUE #( FOR ls_booking IN lt_bookings
                      ( %tky = ls_booking-%tky

                        " --- ACTION CONTROL (BUTTONS) ---
                        " Enable 'Assign Driver' only if status is 'Booked'
                        %action-assignDriver  = COND #( WHEN ls_booking-Status = 'Booked'
                                                        THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

                        " Enable 'Start Trip' only after a driver is assigned
                        %action-startTrip     = COND #( WHEN ls_booking-Status = 'Driver Assigned'
                                                        THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

                        " Enable 'Complete Trip' only if the trip is in progress
                        %action-completeTrip  = COND #( WHEN ls_booking-Status = 'Trip Started'
                                                        THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

                        " --- FIELD CONTROL (READ-ONLY) ---
                        " Disable editing key fields once the process moves past 'Booked'
                        %field-CustomerName   = COND #( WHEN ls_booking-Status <> 'Booked'
                                                        THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )

                        %field-PickupLocation = COND #( WHEN ls_booking-Status <> 'Booked'
                                                        THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )

                        " Driver is Read-Only once the trip is started or completed
                        %field-DriverId       = COND #( WHEN ls_booking-Status = 'Trip Started' OR ls_booking-Status = 'Completed'
                                                        THEN if_abap_behv=>fc-f-read_only ELSE if_abap_behv=>fc-f-unrestricted )
                      ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
    " Typically empty if no specific user-role checks are needed
  ENDMETHOD.

  METHOD setInitialStatus.
    " Logic: New bookings created via the 'Create' button start as 'Booked'
    MODIFY ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky   = key-%tky
                                        Status = 'Booked' ) )
      REPORTED DATA(update_reported).
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD assignDriver.
    " 1. Loop through keys to handle the selection from the Driver Popup
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_key>).
      DATA: lv_vehicle_number TYPE ztaxi_driv_083-vehicle_number.

      " DATABASE LINK: Fetch the vehicle number from your Driver table based on popup selection
      SELECT SINGLE vehicle_number FROM ztaxi_driv_083
        WHERE driver_id = @<ls_key>-%param-DriverId
        INTO @lv_vehicle_number.

      " 2. Update the booking with the Driver ID and Vehicle Number
      MODIFY ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
        ENTITY Booking
          UPDATE FIELDS ( Status DriverId VehicleNumber )
          WITH VALUE #( ( %tky          = <ls_key>-%tky
                          Status        = 'Driver Assigned'
                          DriverId      = <ls_key>-%param-DriverId
                          VehicleNumber = lv_vehicle_number ) )
        REPORTED DATA(reported_modify).

      reported = CORRESPONDING #( DEEP reported_modify ).
    ENDLOOP.

    " 3. Return results so UI refreshes immediately
    READ ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_bookings).
    result = VALUE #( FOR ls_booking IN lt_bookings ( %tky = ls_booking-%tky %param = ls_booking ) ).
  ENDMETHOD.

  METHOD startTrip.
    MODIFY ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( Status )
        WITH VALUE #( FOR key IN keys ( %tky   = key-%tky
                                        Status = 'Trip Started' ) )
      REPORTED DATA(reported_modify).

    READ ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(bookings).
    result = VALUE #( FOR booking in bookings ( %tky = booking-%tky %param = booking ) ).
    reported = CORRESPONDING #( DEEP reported_modify ).
  ENDMETHOD.

  METHOD completeTrip.
    MODIFY ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( Status FareAmount CurrencyCode )
        WITH VALUE #( FOR key IN keys ( %tky         = key-%tky
                                        Status       = 'Completed'
                                        FareAmount   = 500  " Logic for fare can be added here
                                        CurrencyCode = 'INR' ) )
      REPORTED DATA(reported_modify).

    READ ENTITIES OF ZI_TAXIBOOKING_083 IN LOCAL MODE
      ENTITY Booking ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(bookings).
    result = VALUE #( FOR booking in bookings ( %tky = booking-%tky %param = booking ) ).
    reported = CORRESPONDING #( DEEP reported_modify ).
  ENDMETHOD.

ENDCLASS.

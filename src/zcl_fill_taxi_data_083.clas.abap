CLASS zcl_fill_taxi_data_083 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
ENDCLASS.

CLASS zcl_fill_taxi_data_083 IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lt_drivers  TYPE TABLE OF ztaxi_driv_083,
          lt_bookings TYPE TABLE OF ztaxi_book_083.

    " 1. Clear existing data to ensure a clean test environment
    DELETE FROM ztaxi_driv_083.
    DELETE FROM ztaxi_book_083.
    DELETE FROM ztaxi_book_083_d. " Clear the Draft table as well

    " 2. Populate Driver Master Data
    " These IDs (D001, D002, etc.) will be used in your 'Assign Driver' action
    lt_drivers = VALUE #(
      ( driver_id = 'D001' driver_name = 'Kumar'  phone_number = '9876543210' vehicle_number = 'TN-01-AB-1234' availability_status = 'Available' )
      ( driver_id = 'D002' driver_name = 'Santhi' phone_number = '8765432109' vehicle_number = 'TN-02-CD-5678' availability_status = 'Available' )
      ( driver_id = 'D003' driver_name = 'Mani'   phone_number = '7654321098' vehicle_number = 'TN-09-XY-4321' availability_status = 'Available' )
      ( driver_id = 'D004' driver_name = 'Arjun'  phone_number = '9900112233' vehicle_number = 'KA-05-MM-9999' availability_status = 'Available' )
    ).

    " 3. (Optional) Insert one sample Booking to test the 'Read-Only' logic
    " This booking is 'Completed', so the Driver and Customer fields should be locked
    GET TIME STAMP FIELD DATA(lv_timestamp).

    lt_bookings = VALUE #(
      ( booking_uuid   = cl_system_uuid=>create_uuid_x16_static( )
        booking_id     = 'BK-1001'
        customer_name  = 'John Doe'
        pickup_location = 'Airport'
        drop_location   = 'City Center'
        status         = 'Completed'  " Status is Completed -> Triggering Read-Only Logic
        driver_id      = 'D001'
        vehicle_number = 'TN-01-AB-1234'
        fare_amount    = 500
        currency_code  = 'INR'
        local_last_changed_at = lv_timestamp )
    ).

    " 4. Insert records into Database Tables
    INSERT ztaxi_driv_083 FROM TABLE @lt_drivers.
    INSERT ztaxi_book_083 FROM TABLE @lt_bookings.

    " 5. Output Results to Console
    IF sy-subrc = 0.
      out->write( '--- DATA GENERATION SUCCESSFUL ---' ).
      out->write( |{ lines( lt_drivers ) } Drivers inserted.| ).
      out->write( |{ lines( lt_bookings ) } Sample Bookings inserted.| ).
      out->write( 'You can now test the Assign Driver action and Read-Only features.' ).
    ELSE.
      out->write( 'Error: Failed to insert sample data.' ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.

{
    application
    ,sc_main
    ,[{description, "otp operator"}
      ,{vsn, "1.0.0"}
      ,{modules, [sc_app, sc_main, sc_rpc, sc_server, sc_sup,sc_element_sup, sc_store]}
      ,{application, [kernel, stdlib]}
      ,{registerend, []}
      ,{mod, {sc_app, []}}
    ]
}.




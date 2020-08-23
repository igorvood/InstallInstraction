merge into sets_cf updated

using (

        with inserted(name, hostname, port, queue_manager, channel, ssl_config_name) as (

          select 'mq/m1', 'fixme', 1024, 'fixme', 'fixme', null from dual union all

          select 'mq/m2', 'fixme', 1024, 'fixme', 'fixme', null from dual union all

          select 'mq/m3', 'fixme', 1024, 'fixme', 'fixme', null from dual union all

          select 'mq/m4', 'fixme', 1024, 'fixme', 'fixme', null from dual union all

          select 'mq/m5', 'fixme', 1024, 'fixme', 'fixme', null from dual union all

          select '', '', null, '', '', null from dual where 1 = 2

        )

        select ex.rowid rid, inserted.name, inserted.hostname, inserted.port, inserted.queue_manager, inserted.channel, inserted.ssl_config_name

        from inserted full join sets_cf ex on inserted.name = ex.name

      ) cte

on (updated.rowid = cte.rid)

when not matched then

  insert (name, hostname, port, queue_manager, channel, ssl_config_name) values (cte.name, cte.hostname, cte.port, cte.queue_manager, cte.channel, cte.ssl_config_name)

when matched then

  update set updated.name = nvl(cte.name, updated.name),

    updated.hostname = nvl(cte.hostname, updated.hostname),

    updated.port = nvl(cte.port, updated.port),

    updated.queue_manager = nvl(cte.queue_manager, updated.queue_manager),

    updated.channel = nvl(cte.channel, updated.channel),

    updated.ssl_config_name = nvl(cte.ssl_config_name, updated.ssl_config_name)

  where decode(updated.name, cte.name, 1, 0) = 0 or

        decode(updated.hostname, cte.hostname, 1, 0) = 0 or

        decode(updated.port, cte.port, 1, 0) = 0 or

        decode(updated.queue_manager, cte.queue_manager, 1, 0) = 0 or

        decode(updated.channel, cte.channel, 1, 0) = 0 or

        decode(updated.ssl_config_name, cte.ssl_config_name, 1, 0) = 0 or

        updated.name is null

  delete where cte.rid is null

/



begin

  dbms_stats.gather_table_stats('JP', 'sets_cf');

end;

/


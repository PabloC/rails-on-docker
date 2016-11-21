#!/usr/bin/env puma

daemonize false

threads 0, 16

bind 'tcp://0.0.0.0:8080'

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

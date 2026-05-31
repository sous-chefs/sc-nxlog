# frozen_string_literal: true

property :conf_dir, String, default: lazy { default_conf_dir }
property :restart_service, [true, false], default: true

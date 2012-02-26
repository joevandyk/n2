class CreateSmtpSettings < ActiveRecord::Migration
  def change
    execute "

create table smtp_authentication_types (
  type text primary key
);
insert into smtp_authentication_types values ('plain'), ('login'), ('cram_md5');

create table smtp_openssl_verify_modes (
  type text primary key
);

insert into smtp_openssl_verify_modes values
('none'),
('peer'),
('client_once'),
('fail_if_no_peer_cert')
;

create table smtp_settings (
  site_id integer primary key references sites(id),
  address text not null,
  port integer not null,
  domain text not null,
  authentication_type text references smtp_authentication_types not null,
  user_name text not null,
  password text not null,
  enable_starttls_auto boolean default false not null,
  openssl_verify_mode text references smtp_openssl_verify_modes not null
);
    "
  end
end

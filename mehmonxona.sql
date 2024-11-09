CREATE OR REPLACE FUNCTION update_updateAt_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updateAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create table guests (
	id bigserial primary key not null,
	ism varchar(90) not null,
	contact_info jsonb,
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);


CREATE TRIGGER set_updateAt
BEFORE UPDATE ON guests
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


create table rooms (
	id bigserial primary key not null,
	room_number varchar(50) not null,
	room_type varchar(90) not null, 
	price_per_night numeric(13,2) not null,
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);

CREATE TRIGGER set_updateAt
BEFORE UPDATE ON rooms
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


create type holat_enum as enum ('tasdiqlangan', 'ro''yxatdan o''tgan', 'tekshirildi', 'bekor qilingan');

create table reservations (
	id bigserial primary key not null,
	guest_id bigint references guests(id),
	room_id bigint references rooms(id),
	check_in_date date not null,
	check_out_date date not null,
	holat holat_enum default 'ro''yxatdan o''tgan',
	createAt timestamp default CURRENT_TIMESTAMP,
	updateAt timestamp default CURRENT_TIMESTAMP
);

CREATE TRIGGER set_updateAt
BEFORE UPDATE ON reservations
FOR EACH ROW
EXECUTE FUNCTION update_updateAt_column();


INSERT INTO guests (ism, contact_info)
VALUES 
('Diyorbek Islomov', 
  '{"telefon": "+998901234567", "elektron_pochta": "diyorbek@mail.com", "manzil": "Toshkent, Olmazor tuman"}'),
 
('Shahzod O''ktamov', 
  '{"telefon": "+998912345678", "elektron_pochta": "shahzod@mail.com", "manzil": "Toshkent, Yunusobod tuman"}'),
  
('Nilufar Yusupova', 
  '{"telefon": "+998930123456", "elektron_pochta": "nilufar@mail.com", "manzil": "Samarqand, 6-kvartal"}'),
  
('Gulbahor Tursunova', 
  '{"telefon": "+998935678901", "elektron_pochta": "gulbahor@mail.com", "manzil": "Buxoro, Mustaqillik ko''chasi"}'),
  
('Akmal Nurmatov', 
  '{"telefon": "+998991234567", "elektron_pochta": "akmal@mail.com", "manzil": "Andijon, Bog''ishamol"}'),
  
('Javohir Rahmonov', 
  '{"telefon": "+998935432109", "elektron_pochta": "javohir@mail.com", "manzil": "Farg''ona, Olimqoyli"}'),
  
('Maftuna Karimova', 
  '{"telefon": "+998907654321", "elektron_pochta": "maftuna@mail.com", "manzil": "Namangan, Toshkent ko''chasi"}');


INSERT INTO rooms (room_number, room_type, price_per_night)
VALUES 
('A101', 'Single', 50.00),
('B202', 'Double', 75.00),
('C303', 'Suite', 120.00),
('D404', 'Family', 100.00),
('E505', 'Penthouse', 200.00);


INSERT INTO reservations (guest_id, room_id, check_in_date, check_out_date, holat)
VALUES 
(1, 3, '2024-02-08', '2024-02-10', 'ro''yxatdan o''tgan'),
(4, 2, '2024-03-15', '2024-03-20', 'tasdiqlangan'),
(3, 4, '2024-04-01', '2024-04-05', 'tekshirildi'),
(6, 1, '2024-05-10', '2024-05-15', 'bekor qilingan');

update reservations set check_in_date = '2024-02-09', check_out_date = '2024-02-11', holat = 'tekshirildi' where id = 4;

-- Muayyan reservation ni o'chirish
delete from guests where id = 3;
delete from rooms where id = 4;
delete from reservations where id = 3;

-- Malum bir sana oralig'idagi bron qilingan mehmon ism va xonasini chiqarish
select g.ism, r.room_number, r.room_type, r.price_per_night, res.id, res.holat, res.check_in_date, res.check_out_date from reservations res join guests g on res.guest_id = g.id join rooms r on res.room_id = r.id where res.check_in_date between '2024-03-20' and '2024-05-11';


-- Malum sana oralig'ida xonada qolgan mehmon malumotlari
select g.ism, r.room_number, r.room_type, r.price_per_night, res.id, res.holat, res.check_in_date, res.check_out_date from reservations res join guests g on res.guest_id = g.id join rooms r on res.room_id = r.id where res.check_in_date between '2024-02-05' and '2024-03-16' and res.holat = 'tasdiqlangan';
import 'dart:io';

class Room {
  int roomNumber;
  String roomType;
  double price;
  bool isBooked;

  Room(this.roomNumber, this.roomType, this.price, this.isBooked);

  void bookRoom() {
    if (isBooked) {
      print('ห้อง $roomNumber ถูกจองแล้ว');
    } else {
      isBooked = true;
      print('จองห้อง $roomNumber สำเร็จ');
    }
  }

  void cancelBooking() {
    if (isBooked) {
      isBooked = false;
      print('ยกเลิกการจองห้อง $roomNumber สำเร็จ');
    } else {
      print('ห้อง $roomNumber ยังไม่ได้ถูกจอง');
    }
  }

  void displayDetails() {
    print('หมายเลขห้อง: $roomNumber');
    print('ประเภทห้อง: $roomType');
    print('ราคาต่อคืน: $price');
    print('สถานะการจองห้อง: ${isBooked ? "จองแล้ว" : "ยังไม่ได้จอง"}');
  }
}

// ---------------------------------------------------------------------------

class Guest {
  String name;
  int guestId;
  List<Room> bookedRooms;

  Guest(this.name, this.guestId) : bookedRooms = [];

  void bookRoom(Room room) {
    if (!room.isBooked) {
      room.bookRoom();
      bookedRooms.add(room);
      print('$name จองห้อง ${room.roomNumber} สำเร็จ');
    } else {
      print('ไม่สามารถจองห้อง ${room.roomNumber} ได้ เนื่องจากห้องถูกจองแล้ว');
    }
  }

  void cancelRoom(Room room) {
    if (room.isBooked && bookedRooms.contains(room)) {
      room.cancelBooking();
      bookedRooms.remove(room);
      print('$name ยกเลิกการจองห้อง ${room.roomNumber} สำเร็จ');
    } else {
      print('$name ไม่สามารถยกเลิกการจองห้อง ${room.roomNumber} ได้');
    }
  }

  void displayDetails() {
    print('ชื่อผู้เข้าพัก: $name');
    print('หมายเลขผู้เข้าพัก: $guestId');
    print('รายการห้องที่จอง:');
    for (var room in bookedRooms) {
      room.displayDetails();
    }
  }
}

// ---------------------------------------------------------------------------

class Hotel {
  List<Room> rooms;
  List<Guest> guests;

  Hotel()
      : rooms = [],
        guests = [];

  void addRoom(Room room) {
    rooms.add(room);
    print('เพิ่มห้อง ${room.roomNumber} สำเร็จ');
  }

  void removeRoom(int roomNumber) {
    Room? room = getRoom(roomNumber);
    if (room != null) {
      rooms.remove(room);
      print('ลบห้อง $roomNumber สำเร็จ');
    } else {
      print('ไม่พบห้อง $roomNumber');
    }
  }

  void updateRoom(
      int roomNumber, String roomType, double price, bool isBooked) {
    Room? room = getRoom(roomNumber);
    if (room != null) {
      room.roomType = roomType;
      room.price = price;
      room.isBooked = isBooked;
      print('แก้ไขห้อง $roomNumber สำเร็จ');
    } else {
      print('ไม่พบห้อง $roomNumber');
    }
  }

  void registerGuest(Guest guest) {
    guests.add(guest);
    print('ลงทะเบียนผู้เข้าพัก ${guest.name} สำเร็จ');
  }

  void removeGuest(int guestId) {
    Guest? guest = getGuest(guestId);
    if (guest != null) {
      guests.remove(guest);
      print('ลบผู้เข้าพัก $guestId สำเร็จ');
    } else {
      print('ไม่พบผู้เข้าพัก $guestId');
    }
  }

  void updateGuest(int guestId, String name) {
    Guest? guest = getGuest(guestId);
    if (guest != null) {
      guest.name = name;
      print('แก้ไขข้อมูลผู้เข้าพัก $guestId สำเร็จ');
    } else {
      print('ไม่พบผู้เข้าพัก $guestId');
    }
  }

  void bookRoom(int guestId, int roomNumber) {
    Room? room = getRoom(roomNumber);
    Guest? guest = getGuest(guestId);
    if (room != null && guest != null) {
      guest.bookRoom(room);
    } else {
      print('ไม่สามารถจองห้องได้');
    }
  }

  void cancelRoom(int guestId, int roomNumber) {
    Room? room = getRoom(roomNumber);
    Guest? guest = getGuest(guestId);
    if (room != null && guest != null) {
      guest.cancelRoom(room);
    } else {
      print('ไม่สามารถยกเลิกการจองห้องได้');
    }
  }

  Room? getRoom(int roomNumber) {
    for (var room in rooms) {
      if (room.roomNumber == roomNumber) {
        return room;
      }
    }
    return null;
  }

  Guest? getGuest(int guestId) {
    for (var guest in guests) {
      if (guest.guestId == guestId) {
        return guest;
      }
    }
    return null;
  }

  void displayDetails() {
    print('รายละเอียดห้องพักทั้งหมด:');
    for (var room in rooms) {
      room.displayDetails();
    }
    print('รายละเอียดผู้เข้าพักทั้งหมด:');
    for (var guest in guests) {
      guest.displayDetails();
    }
  }

  void search(String query) {
    bool found = false;
    for (var room in rooms) {
      if (room.roomNumber.toString().contains(query) ||
          room.roomType.toLowerCase().contains(query.toLowerCase())) {
        room.displayDetails();
        found = true;
      }
    }
    for (var guest in guests) {
      if (guest.name.toLowerCase().contains(query.toLowerCase()) ||
          guest.guestId.toString().contains(query)) {
        guest.displayDetails();
        found = true;
      }
    }
    if (!found) {
      print('ไม่พบข้อมูลที่ค้นหา');
    }
  }
}

// ------------------------------------------------------------------------

void main() {
  Hotel hotel = Hotel();
  while (true) {
    print('\n---------[ ระบบจัดการโรงแรม ]---------');
    print('1. Menu Item');
    print('2. Search');
    print('Q. Exit');
    stdout.write('Please enter your choice (1-2 or Q): ');
    String? choice = stdin.readLineSync();

    if (choice == null || choice.isEmpty) {
      print('กรุณาใส่ตัวเลือกที่ถูกต้อง');
      continue;
    }

    switch (choice) {
      case '1':
        displayMenu(hotel);
        break;
      case '2':
        stdout.write('Enter search query: ');
        String? query = stdin.readLineSync();
        if (query != null && query.isNotEmpty) {
          hotel.search(query);
        } else {
          print('กรุณาใส่คำค้นหา');
        }
        break;
      case 'Q':
      case 'q':
        print('ออกจากระบบ');
        return;
      default:
        print('เมนูไม่ถูกต้อง');
    }
  }
}

void displayMenu(Hotel hotel) {
  while (true) {
    print('\n---------[ ระบบจัดการโรงแรม ]---------');
    print('1. จัดการห้องพัก');
    print('2. จัดการผู้เข้าพัก');
    print('3. จองห้องพัก');
    print('4. ยกเลิกการจองห้องพัก');
    print('Q. กลับไปเมนูหลัก');
    stdout.write('เลือกเมนู (1-4 หรือ Q): ');
    String? choice = stdin.readLineSync();

    if (choice == null || choice.isEmpty) {
      print('กรุณาใส่ตัวเลือกที่ถูกต้อง');
      continue;
    }

    switch (choice) {
      case '1':
        manageRooms(hotel);
        break;
      case '2':
        manageGuests(hotel);
        break;
      case '3':
        bookRoom(hotel);
        break;
      case '4':
        cancelRoom(hotel);
        break;
      case 'Q':
      case 'q':
        return;
      default:
        print('เมนูไม่ถูกต้อง');
    }
  }
}

void manageRooms(Hotel hotel) {
  print('\n---------[ จัดการห้องพัก ]---------');
  print('1. เพิ่มห้องพัก');
  print('2. แก้ไขห้องพัก');
  print('3. ลบห้องพัก');
  print('4. กลับเมนูหลัก');
  stdout.write('เลือกเมนู (1-4 หรือ Q): ');
  String? choice = stdin.readLineSync();

  if (choice == null || choice.isEmpty) {
    print('กรุณาใส่ตัวเลือกที่ถูกต้อง');
    return;
  }

  switch (choice) {
    case '1':
      stdout.write('หมายเลขห้อง: ');
      int? roomNumber = int.tryParse(stdin.readLineSync()!);
      if (roomNumber == null) {
        print('หมายเลขห้องไม่ถูกต้อง');
        return;
      }
      stdout.write('ประเภทห้อง (Single, Double, Suite): ');
      String? roomType = stdin.readLineSync();
      if (roomType == null || roomType.isEmpty) {
        print('ประเภทห้องไม่ถูกต้อง');
        return;
      }
      stdout.write('ราคาต่อคืน: ');
      double? price = double.tryParse(stdin.readLineSync()!);
      if (price == null) {
        print('ราคาต่อคืนไม่ถูกต้อง');
        return;
      }
      Room room = Room(roomNumber, roomType, price, false);
      hotel.addRoom(room);
      break;
    case '2':
      stdout.write('หมายเลขห้องที่ต้องการแก้ไข: ');
      int? roomNumber = int.tryParse(stdin.readLineSync()!);
      if (roomNumber == null) {
        print('หมายเลขห้องไม่ถูกต้อง');
        return;
      }
      stdout.write('ประเภทห้องใหม่ (Single, Double, Suite): ');
      String? roomType = stdin.readLineSync();
      if (roomType == null || roomType.isEmpty) {
        print('ประเภทห้องไม่ถูกต้อง');
        return;
      }
      stdout.write('ราคาต่อคืนใหม่: ');
      double? price = double.tryParse(stdin.readLineSync()!);
      if (price == null) {
        print('ราคาต่อคืนไม่ถูกต้อง');
        return;
      }
      stdout.write('สถานะการจองห้อง (true/false): ');
      bool? isBooked = stdin.readLineSync()!.toLowerCase() == 'true';
      hotel.updateRoom(roomNumber, roomType, price, isBooked);
      break;
    case '3':
      stdout.write('หมายเลขห้องที่ต้องการลบ: ');
      int? roomNumber = int.tryParse(stdin.readLineSync()!);
      if (roomNumber == null) {
        print('หมายเลขห้องไม่ถูกต้อง');
        return;
      }
      hotel.removeRoom(roomNumber);
      break;
    case '4':
      return;
    default:
      print('เมนูไม่ถูกต้อง');
  }
}

void manageGuests(Hotel hotel) {
  print('\n---------[ จัดการผู้เข้าพัก ]---------');
  print('1. เพิ่มผู้เข้าพัก');
  print('2. แก้ไขผู้เข้าพัก');
  print('3. ลบผู้เข้าพัก');
  print('4. กลับเมนูหลัก');
  stdout.write('เลือกเมนู (1-4 หรือ Q): ');
  String? choice = stdin.readLineSync();

  if (choice == null || choice.isEmpty) {
    print('กรุณาใส่ตัวเลือกที่ถูกต้อง');
    return;
  }

  switch (choice) {
    case '1':
      stdout.write('ชื่อผู้เข้าพัก: ');
      String? name = stdin.readLineSync();
      if (name == null || name.isEmpty) {
        print('ชื่อผู้เข้าพักไม่ถูกต้อง');
        return;
      }
      stdout.write('หมายเลขผู้เข้าพัก: ');
      int? guestId = int.tryParse(stdin.readLineSync()!);
      if (guestId == null) {
        print('หมายเลขผู้เข้าพักไม่ถูกต้อง');
        return;
      }
      Guest guest = Guest(name, guestId);
      hotel.registerGuest(guest);
      break;
    case '2':
      stdout.write('หมายเลขผู้เข้าพักที่จะแก้ไข: ');
      int? guestId = int.tryParse(stdin.readLineSync()!);
      if (guestId == null) {
        print('หมายเลขผู้เข้าพักไม่ถูกต้อง');
        return;
      }
      stdout.write('ชื่อใหม่: ');
      String? name = stdin.readLineSync();
      if (name == null || name.isEmpty) {
        print('ชื่อผู้เข้าพักไม่ถูกต้อง');
        return;
      }
      hotel.updateGuest(guestId, name);
      break;
    case '3':
      stdout.write('หมายเลขผู้เข้าพักที่ต้องการลบ: ');
      int? guestId = int.tryParse(stdin.readLineSync()!);
      if (guestId == null) {
        print('หมายเลขผู้เข้าพักไม่ถูกต้อง');
        return;
      }
      hotel.removeGuest(guestId);
      break;
    case '4':
      return;
    default:
      print('เมนูไม่ถูกต้อง');
  }
}

void bookRoom(Hotel hotel) {
  stdout.write('หมายเลขผู้เข้าพัก: ');
  int? guestId = int.tryParse(stdin.readLineSync()!);
  if (guestId == null) {
    print('หมายเลขผู้เข้าพักไม่ถูกต้อง');
    return;
  }
  stdout.write('หมายเลขห้องพัก: ');
  int? roomNumber = int.tryParse(stdin.readLineSync()!);
  if (roomNumber == null) {
    print('หมายเลขห้องพักไม่ถูกต้อง');
    return;
  }
  hotel.bookRoom(guestId, roomNumber);
}

void cancelRoom(Hotel hotel) {
  stdout.write('หมายเลขผู้เข้าพัก: ');
  int? guestId = int.tryParse(stdin.readLineSync()!);
  if (guestId == null) {
    print('หมายเลขผู้เข้าพักไม่ถูกต้อง');
    return;
  }
  stdout.write('หมายเลขห้องพัก: ');
  int? roomNumber = int.tryParse(stdin.readLineSync()!);
  if (roomNumber == null) {
    print('หมายเลขห้องพักไม่ถูกต้อง');
    return;
  }
  hotel.cancelRoom(guestId, roomNumber);
}

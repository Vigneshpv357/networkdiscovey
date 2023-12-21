import 'package:network_discovery/network_discovery.dart';


Future<void> main() async { // Added 'async' here
  try {
    // Must be async function
    final String deviceIP = await NetworkDiscovery.discoverDeviceIpAddress();

    if (deviceIP.isNotEmpty) {
      print(deviceIP);
      // Can use to get subnet from IP Address
      final String subnet = deviceIP.substring(0, deviceIP.lastIndexOf('.'));
      const List<int> ports = [8989];
      final stream = NetworkDiscovery.discoverMultiplePorts(subnet, ports);

      int found = 0;
      stream.listen((NetworkAddress addr) {
        found++;
        print('Found device: ${addr.ip}: $ports');
      }).onDone(() => print('Finish. Found $found device(s)'));
    } else {
      print("Couldn't get IP Address");
    }

  
  } catch (error) {
    print("Error: $error"); // Handle any errors during network operations
  }
}



// // Copyright 2013 The Flutter Authors. All rights reserved.
// // Use of this source code is governed by a BSD-style license that can be
// // found in the LICENSE file.

// // Example script to illustrate how to use the mdns package to discover the port
// // of a Dart observatory over mDNS.
// import 'dart:io';

// import 'package:multicast_dns/multicast_dns.dart';

// Future<void> main() async {


//   // const String name = '_dartobservatory._tcp.local';
//   const String name = '_http._tcp';
//  // final MDnsClient client = MDnsClient();
//   // Start the client with default options.
//   final MDnsClient client = MDnsClient(rawDatagramSocketFactory:
//     (dynamic host, int port,
//         {bool? reuseAddress, bool? reusePort, int? ttl}) {
//   return RawDatagramSocket.bind(host, port,
//       reuseAddress: true, reusePort: false, ttl: ttl!);
// });  
//   await client.start();
//   var clilook = client
//       .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name));
//       print(await clilook.isEmpty);
//   // Get the PTR record for the service.
//   await for (final PtrResourceRecord ptr in client
//       .lookup<PtrResourceRecord>(ResourceRecordQuery.serverPointer(name))) {
//         print("1");
//     // Use the domainName from the PTR record to get the SRV record,
//     // which will have the port and local hostname.
//     // Note that duplicate messages may come through, especially if any
//     // other mDNS queries are running elsewhere on the machine.
//     await for (final SrvResourceRecord srv in client.lookup<SrvResourceRecord>(
//         ResourceRecordQuery.service(ptr.domainName))) {
//           print("2");
//       // Domain name will be something like "io.flutter.example@some-iphone.local._dartobservatory._tcp.local"
//       final String bundleId =
//           ptr.domainName; //.substring(0, ptr.domainName.indexOf('@'));
//       print('Dart observatory instance found at '
//           '${srv.target}:${srv.port} for "$bundleId".');
//     }
//   }
//   client.stop();

//   print('Done.');
// }
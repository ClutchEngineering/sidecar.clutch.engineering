import Foundation

import Slipstream

struct VehicleSupport: View {
  var body: some View {
    Page(
      "Vehicle Support",
      path: "/scanning/vehicle-support",
      description: "Sidecar vehicle support status.",
      keywords: [
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      ScanningNavigation()

      Container {
        Section {
          VStack(alignment: .center) {
            Div {
              H1("Vehicle Support Status")
                .fontSize(.fourXLarge)
                .bold()
                .fontDesign("rounded")
              Text("Electric Sidecar's vehicle support matrix")
            }
            .textAlignment(.center)
          }
          .padding(.vertical, 16)
        }
      }

      PostView("""
<table class="min-w-full bg-white border border-gray-200 rounded-lg">
<thead>
 <tr class="bg-gray-200 text-left text-sm uppercase font-bold">
  <th class="py-3 px-4 border-b">Vehicle Make</th>
  <th class="py-3 px-4 border-b">Vehicle Model</th>
  <th class="py-3 px-4 border-b">Build Status</th>
 </tr>
</thead>
<tbody>
 <!-- Audi -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold">Audi</td>
  <td class="py-3 px-4 border-b">e-tron</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Audi-e-tron">
    <img
     src="https://github.com/ElectricSidecar/Audi-e-tron/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- BMW -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold" rowspan="3">BMW</td>
  <td class="py-3 px-4 border-b">4-series</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/BMW-4-series">
    <img
     src="https://github.com/ElectricSidecar/BMW-4-series/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b">i4</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/BMW-i4">
    <img
     src="https://github.com/ElectricSidecar/BMW-i4/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b">iX3</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/BMW-iX3">
    <img
     src="https://github.com/ElectricSidecar/BMW-iX3/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- BYD -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">BYD</td>
  <td class="py-3 px-4 border-b">Atto 3</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/BYD-Atto-3">
    <img
     src="https://github.com/ElectricSidecar/BYD-Atto-3/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Dolphin Mini</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/BYD-Dolphin-Mini">
    <img
     src="https://github.com/ElectricSidecar/BYD-Dolphin-Mini/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Chevrolet -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Chevrolet</td>
  <td class="py-3 px-4 border-b">Bolt EV</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Chevrolet-Bolt-EV">
    <img
     src="https://github.com/ElectricSidecar/Chevrolet-Bolt-EV/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Citroen -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Citroen</td>
  <td class="py-3 px-4 border-b">CZero</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Citroen-CZero">
    <img
     src="https://github.com/ElectricSidecar/Citroen-CZero/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">E-C4</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Citroen-E-C4">
    <img
     src="https://github.com/ElectricSidecar/Citroen-E-C4/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Dodge -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Dodge</td>
  <td class="py-3 px-4 border-b">Challenger</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Dodge-Challenger">
    <img
     src="https://github.com/ElectricSidecar/Dodge-Challenger/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Ford -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Ford</td>
  <td class="py-3 px-4 border-b">Escape</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Ford-Escape">
    <img
     src="https://github.com/ElectricSidecar/Ford-Escape/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Mustang</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Ford-Mustang">
    <img
     src="https://github.com/ElectricSidecar/Ford-Mustang/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Honda -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Honda</td>
  <td class="py-3 px-4 border-b">M-NV</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Honda-M-NV">
    <img
     src="https://github.com/ElectricSidecar/Honda-M-NV/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Hyundai -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Hyundai</td>
  <td class="py-3 px-4 border-b">IONIQ 5</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Hyundai-IONIQ-5">
    <img
     src="https://github.com/ElectricSidecar/Hyundai-IONIQ-5/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Kona Electric</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Hyundai-Kona-Electric">
    <img
     src="https://github.com/ElectricSidecar/Hyundai-Kona-Electric/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Jeep -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Jeep</td>
  <td class="py-3 px-4 border-b">Wrangler</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Jeep-Wrangler">
    <img
     src="https://github.com/ElectricSidecar/Jeep-Wrangler/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Kia -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Kia</td>
  <td class="py-3 px-4 border-b">EV9</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Kia-EV9">
    <img
     src="https://github.com/ElectricSidecar/Kia-EV9/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Sportage HEV</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Kia-Sportage-HEV">
    <img
     src="https://github.com/ElectricSidecar/Kia-Sportage-HEV/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- MG -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">MG</td>
  <td class="py-3 px-4 border-b">MG4</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/MG-MG4">
    <img
     src="https://github.com/ElectricSidecar/MG-MG4/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Mercedes-Benz -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Mercedes-Benz</td>
  <td class="py-3 px-4 border-b">EQS Class Sedan</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Mercedes-Benz-EQS-Class-Sedan">
    <img
     src="https://github.com/ElectricSidecar/Mercedes-Benz-EQS-Class-Sedan/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">S Class</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Mercedes-Benz-S-Class">
    <img
     src="https://github.com/ElectricSidecar/Mercedes-Benz-S-Class/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Mitsubishi -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Mitsubishi</td>
  <td class="py-3 px-4 border-b">Outlander PHEV</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Mitsubishi-Outlander-PHEV">
    <img
     src="https://github.com/ElectricSidecar/Mitsubishi-Outlander-PHEV/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Nissan -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="2">Nissan</td>
  <td class="py-3 px-4 border-b">Juke</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Nissan-Juke">
    <img
     src="https://github.com/ElectricSidecar/Nissan-Juke/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Leaf</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Nissan-Leaf">
    <img
     src="https://github.com/ElectricSidecar/Nissan-Leaf/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Opel -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Opel</td>
  <td class="py-3 px-4 border-b">Corsa</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Opel-Corsa">
    <img
     src="https://github.com/ElectricSidecar/Opel-Corsa/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Porsche -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="8">Porsche</td>
  <td class="py-3 px-4 border-b">911</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-911">
    <img
     src="https://github.com/ElectricSidecar/Porsche-911/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">718</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-718">
    <img
     src="https://github.com/ElectricSidecar/Porsche-718/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">718 Boxster</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-718-Boxster">
    <img
     src="https://github.com/ElectricSidecar/Porsche-718-Boxster/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Cayenne</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-Cayenne">
    <img
     src="https://github.com/ElectricSidecar/Porsche-Cayenne/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Cayman</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-Cayman">
    <img
     src="https://github.com/ElectricSidecar/Porsche-Cayman/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Macan</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-Macan">
    <img
     src="https://github.com/ElectricSidecar/Porsche-Macan/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Panamera</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-Panamera">
    <img
     src="https://github.com/ElectricSidecar/Porsche-Panamera/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Taycan</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Porsche-Taycan">
    <img
     src="https://github.com/ElectricSidecar/Porsche-Taycan/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Ram -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Ram</td>
  <td class="py-3 px-4 border-b">1500</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Ram-1500">
    <img
     src="https://github.com/ElectricSidecar/Ram-1500/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Rivian -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold">Rivian</td>
  <td class="py-3 px-4 border-b">R1T</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Rivian-R1T">
    <img
     src="https://github.com/ElectricSidecar/Rivian-R1T/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Tesla -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold" rowspan="4">Tesla</td>
  <td class="py-3 px-4 border-b">Model 3</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Tesla-Model-3">
    <img
     src="https://github.com/ElectricSidecar/Tesla-Model-3/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b">Model S</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Tesla-Model-S">
    <img
     src="https://github.com/ElectricSidecar/Tesla-Model-S/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b">Model X</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Tesla-Model-X">
    <img
     src="https://github.com/ElectricSidecar/Tesla-Model-X/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b">Model Y</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Tesla-Model-Y">
    <img
     src="https://github.com/ElectricSidecar/Tesla-Model-Y/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Toyota -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold" rowspan="5">Toyota</td>
  <td class="py-3 px-4 border-b">4Runner</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Toyota-4Runner">
    <img
     src="https://github.com/ElectricSidecar/Toyota-4Runner/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Avalon</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Toyota-Avalon">
    <img
     src="https://github.com/ElectricSidecar/Toyota-Avalon/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Camry</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Toyota-Camry">
    <img
     src="https://github.com/ElectricSidecar/Toyota-Camry/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">Ist</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Toyota-Ist">
    <img
     src="https://github.com/ElectricSidecar/Toyota-Ist/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b">RAV4</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Toyota-RAV4">
    <img
     src="https://github.com/ElectricSidecar/Toyota-RAV4/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Volvo -->
 <tr class="bg-gray-100">
  <td class="py-3 px-4 border-b font-semibold">Volvo</td>
  <td class="py-3 px-4 border-b">XC40 Recharge</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Volvo-XC40-Recharge">
    <img
     src="https://github.com/ElectricSidecar/Volvo-XC40-Recharge/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
 <!-- Voyah -->
 <tr class="bg-gray-50">
  <td class="py-3 px-4 border-b font-semibold">Voyah</td>
  <td class="py-3 px-4 border-b">Free</td>
  <td class="py-3 px-4 border-b">
   <a href="https://github.com/ElectricSidecar/Voyah-Free">
    <img
     src="https://github.com/ElectricSidecar/Voyah-Free/actions/workflows/json-yaml-validate.yml/badge.svg?label=foo"
     alt="Build Status">
   </a>
  </td>
 </tr>
</tbody>
</table>
""")
    }
  }
}



part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textFieldController = TextEditingController();

  List<Province> provincesList = [];

  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;

  bool isLoading = false;
  bool isLoadingCityOrigin = false;
  bool isLoadingCityDestination = false;

  Future<void> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provincesList = value;
        isLoading = false;
      });
    });
  }

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;
  dynamic selectedCourier;

  List<City> citiesList = [];
  List<City> citiesDestinationList = [];

  Future<void> getCities(var provId) async {
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        citiesList = value;
        isLoadingCityOrigin = false;
      });
    });
  }

// Mendapatkan daftar kota asal berdasarkan provinsi
  Future<void> getCitiesDestination(var provId) async {
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        citiesDestinationList = value;
        isLoadingCityDestination = false;
      });
    });
  }

  List<Costs> costsList = [];

  // Mendapatkan estimasi biaya pengiriman
  Future<void> getCosts(var origin, var destination, var weight, var courier) async {
    await MasterDataService.getCost(origin, destination, weight, courier).then((value) {
      setState(() {
        costsList = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mendapatkan daftar provinsi saat halaman diinisialisasi
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(""),
        centerTitle: true,
        backgroundColor: Colors.purple, 
        titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
               // Widget untuk memilih kurir dan berat paket
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                       // Widget untuk memilih provinsi asal
                      width: 160, 
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        value: selectedCourier,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 4,
                        style: const TextStyle(color: Colors.black),
                        hint: selectedCourier == null
                            ? const Text('Pilih Courier')
                            : Text(selectedCourier),
                        items: ["jne", "tiki", "pos"]
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCourier = newValue;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: 160, // Ubah lebar menjadi 160
                        child: TextField(
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            hintText: 'Berat (gr)',
                            contentPadding: const EdgeInsets.all(0.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Origin",
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160, // Ubah lebar menjadi 160
                        child: DropdownButton(
                          isExpanded: true,
                          value: selectedProvinceOrigin,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 4,
                          style: const TextStyle(color: Colors.black),
                          hint: selectedProvinceOrigin == null
                              ? const Text('Pilih Provinsi')
                              : Text(selectedProvinceOrigin.province),
                          items: provincesList
                              .map<DropdownMenuItem<Province>>(
                                (Province value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedProvinceOrigin = newValue;
                              isLoadingCityOrigin = true;
                              getCities(selectedProvinceOrigin.provinceId);
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 160, // Ubah lebar menjadi 160
                        child: isLoadingCityOrigin == true
                            ? UiLoading.loadingSmall()
                            : DropdownButton(
                                isExpanded: true,
                                value: selectedCityOrigin,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 4,
                                style: const TextStyle(color: Colors.black),
                                hint: selectedCityOrigin == null
                                    ? const Text('Pilih Kota')
                                    : Text(selectedCityOrigin.cityName),
                                items: citiesList
                                    .map<DropdownMenuItem<City>>(
                                      (City value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value.cityName.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCityOrigin = newValue;
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Destination",
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 160, // Ubah lebar menjadi 160
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          value: selectedProvinceDestination,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 4,
                          style: const TextStyle(color: Colors.black),
                          hint: selectedProvinceDestination == null
                              ? const Text('Pilih Provinsi')
                              : Text(selectedProvinceDestination.province),
                          items: provincesList
                              .map<DropdownMenuItem<Province>>(
                                (Province value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()),
                                ),
                              )
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedProvinceDestination = newValue;
                              isLoadingCityDestination = true;
                              getCitiesDestination(
                                selectedProvinceDestination.provinceId,
                              );
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 160, // Ubah lebar menjadi 160
                        child: isLoadingCityDestination == true
                            ? UiLoading.loadingSmall()
                            : DropdownButtonFormField(
                                isExpanded: true,
                                value: selectedCityDestination,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 20,
                                elevation: 4,
                                style: const TextStyle(color: Colors.black),
                                hint: selectedCityDestination == null
                                    ? const Text('Pilih Kota')
                                    : Text(selectedCityDestination.cityName),
                                items: citiesDestinationList
                                    .map<DropdownMenuItem<City>>(
                                      (City value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value.cityName.toString()),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCityDestination = newValue;
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0), 
            ElevatedButton(
              // Memeriksa apakah semua data yang diperlukan sudah dipilih/selesai diisi sebelum menghitung estimasi harga
              onPressed: () {
                if (selectedCityDestination != null &&
                    selectedCityOrigin != null &&
                    selectedCourier != null &&
                    _textFieldController.text.isNotEmpty) {
                 // Memanggil fungsi untuk mendapatkan estimasi harga berdasarkan data yang dipilih
                  getCosts(
                    selectedCityOrigin.cityId,
                    selectedCityDestination.cityId,
                    _textFieldController.text,
                    selectedCourier,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, 
                padding: const EdgeInsets.symmetric(vertical: 10.0), // Mengatur padding secara simetris
              ),
              child: const Text(
                '  Hitung Estimasi Harga  ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16.0),
            costsList.isEmpty
                ? Container(
                    height: 200,
                    child: const Align(
                      alignment: Alignment.center,
                      // Pesan yang ditampilkan jika tidak ada data estimasi harga
                      child: Text("Tidak ada data"),
                    ),
                  )
                : isLoading == true
                // Tampilan loading jika sedang memuat data
                    ? UiLoading.loadingBlock()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: costsList.length,
                        itemBuilder: (context, index) {
                          return CardProvince(costsList[index]);
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
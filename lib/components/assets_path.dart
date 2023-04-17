// OnBoarding Text and image path

List<String> vectorsPath = [
  'assets/vectors/v1.svg',
  'assets/vectors/v2.svg',
  'assets/vectors/v3.svg'
];

List<String> categories = [
  'assets/category/cleaning.png',
  'assets/category/painting.png',
  'assets/category/pluming.png',
  'assets/category/beauty.png',
  'assets/category/repairing.png',
  'assets/category/electrician.png',
  'assets/category/gardening.png',
  'assets/category/laptop.png',
  'assets/category/baber.png',
  'assets/category/air-conditioner.png',
  'assets/category/carpenters.png',
  'assets/category/it.png',
];

List<String> categoriesLabel = [
  'Cleaning',
  'Painting',
  'Pluming',
  'Beauty',
  'Repairing',
  'Electrician',
  'Gardening',
  'Laptop',
  'Baber',
  'Air-Cooler',
  'Carpenters',
  'IT Solution',
];


// Key : Value
Map<String, String> onboardingInfo = {
  'Welcome to Wasta':
      'Wasta is a platform where you can find people\n who have experience at a specific job and you can hire them to do it instead of you!',
  'Who is on Wasta ?':
      'On Wasta platform there are numerous Cleaners,\nPlumbers, Technician, Painter, Barber and expert\nof all majors with years of experience\nwho you can hire them.',
  'Appointments':
      'You can easily set an appointment with the expert\nyou want with a specific service type of a specific\nmajor and set a date & time to meet.'
};

String getImage({required String folderName, required String fileName}) {
  return 'assets/$folderName/$fileName';
}

///

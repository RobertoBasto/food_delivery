class UnboardingContent {
  String image;
  String title;
  String description;

  UnboardingContent({required this.image, required this.title, required this.description});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: 'Pick your food from our menu\nMore than 35 times',
      image: 'images/screen1.png',
      title: 'Select from Our\nBest Menu'),
  UnboardingContent(
      description: 'You can pay cash on delivery and\nCard payment is available',
      image: 'images/screen2.png',
      title: 'Easy and Online Payment'),
  UnboardingContent(
      description: 'Deliver your food at your\nDoorstep',
      image: 'images/screen3.png',
      title: 'Quick Delivery at\nYour Doorstep')
];
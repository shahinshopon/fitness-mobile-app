class Onbording {
  String image;
  String title;
  String discription;

  Onbording(
      {required this.image, required this.title, required this.discription});
}

List<Onbording> contents = [
  Onbording(
      title: 'Physical fitness',
      image:
          'assets/images/onboarding-one.png',
      discription:
          "Physical fitness is a state of health and well-being and, more specifically, the ability to perform aspects of sports, occupations and daily activities "),
  Onbording(
      title: 'Regular physical',
      image:
          'assets/images/onboarding-two.png',
      discription:
          "Regular physical exercises help in maintaining the performance of lungs, heart and other major body organs. It burns off excess calories and keeps our weigh "),
  Onbording(
      title: 'Health fitness',
      image:
          'assets/images/onboarding-three.png',
      discription:
          "If we want better health, we need to start going gym from today. Physical Exercise: Paragraph (150 Words). Everyone wants a better and healthy body. I think you "),
];

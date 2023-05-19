// Flutter
import 'package:flutter/material.dart';

// Components
import 'package:dogo_final_app/components/buttons/button_back.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const ButtonBack(),
        title: const Text('Politique de confidentialité'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: screenWidth * 0.95,
              margin: const EdgeInsets.only(top: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Introduction",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Bienvenue dans Dogo, une application mobile dédiée à proposer des balades à proximité en utilisant votre position GPS. Cette politique de confidentialité vise à vous informer sur la manière dont nous recueillons, utilisons, protégeons et partageons vos informations personnelles.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Informations que nous recueillons",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Pour fournir nos services, nous pouvons recueillir les types d'informations suivants :",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Nom et prénom",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Adresse e-mail",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Image de Google",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Position GPS",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Messages de groupe",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Comment nous utilisons vos informations",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nous utilisons vos informations pour :",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Vous proposer des balades à proximité",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Suivre votre activité",
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Comment nous protégeons vos informations",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nous nous engageons à protéger vos informations. Pour ce faire, nous utilisons Firebase et Firestore, des services de Google, pour stocker et protéger vos informations. Nous mettons en œuvre des mesures de sécurité pour protéger vos informations contre l'accès, la divulgation, la modification et la destruction non autorisés.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Partage de vos informations",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nous ne partageons vos informations avec des tiers que dans le cadre de la fourniture de nos services, comme décrit dans cette politique, ou lorsque nous avons votre consentement.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Vos droits",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Vous avez le droit d'accéder à vos informations, de les corriger, de les supprimer, de limiter leur traitement et de vous opposer à leur traitement.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nous contacter",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Si vous avez des questions ou des préoccupations concernant cette politique de confidentialité, veuillez nous contacter à dogo.app.ecv@gmail.com.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Changements à cette politique de confidentialité",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Nous vous informerons de tout changement en mettant à jour la date de la dernière mise à jour de cette politique de confidentialité.\n\nDernière mise à jour : 19 mai 2023",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

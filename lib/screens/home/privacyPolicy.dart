import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Privacy policy"), elevation: 0.0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "Tutor App Company built the Tutor App app as a Free app. This SERVICE is provided by Tutor App Company at no cost and is intended for use as is." +
                      "This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service." +
                      "If you choose to use our Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that we collect is used for providing and improving the Service. We will not use or share your information with anyone except as described in this Privacy Policy." +
                      "The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Tutor App unless otherwise defined in this Privacy Policy.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  "Information Collection and Use",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information, including but not limited to Name, Email, Phone Number, Location, Age, Profile Image. The information that we request will be retained by us and used as described in this privacy policy.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10),
                Text(
                  "Log data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "We want to inform you that whenever you use our Service, in a case of an error in the app we collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height:10),
                Text(
                  "Security",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height:10),
                Text(
                  "Links to other sites",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height:10),
                Text(
                  "Children's Privacy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case we discover that a child under 13 has provided us with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us so that we will be able to do necessary actions.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                 SizedBox(height:10),
                Text(
                  "Changes to this privacy policy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.This policy is effective as of 2020-09-12",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height:10),
                Text(
                  "Contact us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  "If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at soninaman62626@gmail.com",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ));
  }
}

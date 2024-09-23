import Foundation

import Slipstream

struct PrivacyPolicy: View {
  var body: some View {
    Page(
      "Privacy Policy",
      path: "/privacy-policy/",
      description: "Sidecar minimizes data collection and keeps your private data, private.",
      keywords: [
        "privacy policy",
        "OBD-II",
        "car scanner",
        "trip logger",
        "vehicle diagnostics",
        "vehicle connectivity",
      ]
    ) {
      Container {
        VStack(alignment: .center) {
          HeroIconPuck(url: URL(string: "/gfx/privacy.png")!)

          Div {
            H1("Privacy Policy")
              .fontSize(.fourXLarge)
              .bold()
              .fontDesign("rounded")
            Text("Last updated September 22, 2024")
          }
          .textAlignment(.center)
        }
        .padding(.vertical, 16)

        Article("""
Sidecar is delighted to be our users' choice for understanding the state of their garage.

Overview
--------

This Privacy Notice is meant to help you understand how Fearless Design, LLC, a California limited liability company (**“Fearless”**, **“we”**, **“our”** or **“us”**) collects, uses, stores and shares personal information it collects about you (**“User”“you”** or **“your”**) in connection with your use of Sidecar, our mobile application (hereinafter referred to as **“Mobile App”** or **“Sidecar”**), and how to exercise the choices and rights you have in your information.

1\\. The Scope Of This Policy
----------------------------

This policy applies only to personal information, not to aggregate information or information that does not identify you. Please remember that your use of the Mobile App is also subject to our Terms of Service and certain terms not defined within this Privacy Notice shall have the meanings set forth within the Sidecar Terms of Services.

2\\. The Information We Collect
------------------------------

When you use the Mobile App, the personal information we may collect from you includes, but is not limited to, your Internet Protocol (**“IP”**) address and the country, state and city from which you are accessing the Mobile App. Information such as your name, username, login credentials, Vehicle Identification Number (**“VIN”**), phone number, email address, mailing address and/or physical address are not collected, used, stored or shared by Fearless, and Fearless does not have access to this information by way of your use of the Mobile App.

3\\. How We Use Your Information
-------------------------------

We use your personal information to provide the Mobile App and Connected Vehicle Services, improve the Mobile App and Connected Vehicle Services, and respond to legal proceedings and obligations.

### Providing the Mobile App

We use your personal information to provide an intuitive, useful, efficient, and worthwhile experience on our platform.

### Improving the Mobile App

We are always working to improve your experience and provide you with new and helpful features. To do this, we use your personal information to:

*   Perform research, testing, and analysis;
    
*   Develop new products, features, and services;
    
*   Prevent, find, and resolve software or hardware bugs and issues; and
    
*   Monitor and improve our operations and processes, including security practices, algorithms, and other modeling.

### Responding to Legal Proceedings and Requirements

Sometimes the law, government entities, or other regulatory bodies impose demands and obligations on us with respect to the services we seek to provide. In such a circumstance, we may use your personal information to respond to those demands or obligations.

4\\. How We Store Your Information
---------------------------------

We do not sell your personal information to third parties for money -- no one can buy the personal information we collect from and about you and we do not act as a data broker. All personal information collected by Fearless is stored by Fearless with PostHog, an event-based analytics provider, indefinitely. The personal information stored by Fearless with PostHog is not utilized to provide you with targeted advertisements. PostHog uses the personal information collected by Fearless only to provide Fearless with event-based analytics information that is then used to improve your user experience. PostHog's privacy policy is available [here](https://posthog.com/privacy). You can turn off data being sent to PostHog from the Settings page of the Sidecar app.

We may also share your personal information while negotiating or in relation to a change of corporate control such as a restructuring, merger, or sale of our assets, or where you direct us to.

5\\. Accessing Your Data
-----------------------

If you would like to access your personal information, please email [privacy@electricsidecar.app](mailto:privacy@electricsidecar.app).

6\\. Children's Data
-------------------

Sidecar is not directed to children, and we don't knowingly collect personal information from children under the age of 13. If we find out that a child under 13 has given us personal information, we will take steps to delete that information. If you believe that a child under the age of 13 has given us personal information, please contact us at [privacy@electricsidecar.app](mailto:privacy@electricsidecar.app).

7\\. Links To Third-Party Websites
---------------------------------

The Mobile App may contain links or references to third- party websites, products, or services. Those third parties may have privacy policies that differ from ours. We are not responsible for those third parties and their websites, products or services, and we recommend that you review their policies. Please contact those parties directly if you have any questions about their privacy policies.

8\\. Changes To This Privacy Policy
----------------------------------

We may update this policy from time to time as the Mobile App changes and privacy law evolves. If we update it, we will do so online, and if we make material changes, we will let you know through the Mobile App. When you use Sidecar, you are agreeing to the most recent terms of this policy.

9\\. Contact Us
--------------

If you have any questions or concerns about your privacy or anything in this policy, including if you need to access this policy in an alternative format, we encourage you to contact [privacy@electricsidecar.app](mailto:privacy@electricsidecar.app).
"""
        )
      }
      .padding(.bottom, 16)
    }
  }
}

/*
class Event {
  final String text;
  final String image;
  final String location;
  final Map date;


  const Event({this.text, this.image, this.date, this.location});
}

 final String placeholder = "https://picsum.photos/200/300/?random.png?text=Placeholder";


 final  events = [
  new Event(
    text:
        "Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat‐5",
    image: "https://picsum.photos/800/600/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "BMW says electric car mass production not viable until 2020",
    image: "https://source.unsplash.com/user/erondu/800x600",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Evolution Is the New Deep Learning",
    image: "https://source.unsplash.com/800x600/?nature,water",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "TCP Tracepoints have arrived in Linux",
    image: "https://source.unsplash.com/800x600/?water",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Section 230: A Key Legal Shield for Facebook, Google Is About to Change",
    image: "https://source.unsplash.com/800x600/?light",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "A Visiting Star Jostled Our Solar System 70,000 Years Ago",
    image: "https://source.unsplash.com/800x600/?earth",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Cow Game Extracted Facebook Data",
    image: "https://source.unsplash.com/800x600/?cars",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Ask HN: How do you find freelance work?",
    image: "https://source.unsplash.com/800x600/?technology",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Hedge-fund managers that do the most research will post the best returns",
    image: "https://source.unsplash.com/800x600/?stars",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Number systems of the world, sorted by complexity of counting (2006)",
    image: "https://source.unsplash.com/800x600/?life",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "MIT’s new device can pull water from desert air",
    image: "https://source.unsplash.com/800x600/?food",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "GitLab 10.6 released with CI/CD for GitHub",
    image: "https://source.unsplash.com/800x600/?trains",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Next-Gen Display: MicroLEDs",
    image: "https://source.unsplash.com/800x600/?lifestyle",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Power 9 May Dent X86 Servers: Alibaba, Google, Tencent Test IBM Systems",
    image: "https://source.unsplash.com/800x600/?people",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Show HN: Transfer files to mobile device by scanning a QR code from the terminal",
    image: "https://source.unsplash.com/800x600/?joy",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Types of People Startups Should Hire, but Don’t",
    image: "https://source.unsplash.com/800x600/?ocean",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Steinhaus Longimeter",
    image: "https://source.unsplash.com/800x600/?sports",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Data on 1.2M Facebook users from 2005 (2011) [use archive.org url in thread]",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "The Myth of Authenticity Is Killing Tex-Mex",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Show HN: Asynchronous HTTP/2 client for Python 2.7",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Fractions in the Farey Sequences and the Stern-Brocot Tree",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Understanding CPU port contention",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "Krita 4.0 – A painting app for cartoonists, illustrators, and concept artists",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Cutting ‘Old Heads’ at IBM",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Where to Score: Classified Ads from Haight-Ashbury",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text:
        "TravisBuddy: Adds comments to failed pull requests, tells author what went wrong",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  ),
  new Event(
    text: "Using Technical Debt in Your Favor",
    image: "https://picsum.photos/200/300/?random",
    date: {"day" : "16", "month": "Jan"},
    location: "New Delhi",
  )
];
*/

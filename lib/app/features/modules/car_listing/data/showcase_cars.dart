// Presentation-only car data shared between the listing and detail screens.
// Keeps the showcase cards consistent so a car tapped on the listing shows the
// same specs, rating and price on its detail page.

class ShowcaseCar {
  final String name;
  final String tagline;
  final String image;
  final String category;
  final num pricePerDay;
  final double rating;
  final int reviews;
  final int seats;
  final String transmission;
  final String fuel;
  final int topSpeed; // km/h
  final String power;
  final String description;

  const ShowcaseCar({
    required this.name,
    required this.tagline,
    required this.image,
    required this.category,
    required this.pricePerDay,
    required this.rating,
    required this.reviews,
    required this.seats,
    required this.transmission,
    required this.fuel,
    required this.topSpeed,
    required this.power,
    required this.description,
  });

  String get priceLabel => 'R${pricePerDay.toString()}';

  /// A sensible default used when a screen only knows the car name + image
  /// (e.g. the home screen) and there is no matching entry in [showcaseCars].
  factory ShowcaseCar.fallback({required String name, required String image}) {
    return ShowcaseCar(
      name: name,
      tagline: 'Premium drive',
      image: image,
      category: 'Sport',
      pricePerDay: 1500,
      rating: 4.8,
      reviews: 120,
      seats: 4,
      transmission: 'Auto',
      fuel: 'Petrol',
      topSpeed: 250,
      power: '500 hp',
      description:
          'A high-performance car with refined comfort, cutting-edge tech and '
          'effortless power — ready for your next journey.',
    );
  }

  /// Resolves a [ShowcaseCar] from a name (matching the demo catalogue when
  /// possible), falling back to a generated entry otherwise.
  static ShowcaseCar resolve({required String name, required String image}) {
    for (final car in showcaseCars) {
      if (car.name.toLowerCase() == name.toLowerCase()) return car;
    }
    return ShowcaseCar.fallback(name: name, image: image);
  }
}

const List<String> carCategories = ['All', 'Sport', 'Luxury', 'SUV', 'Electric'];

const List<ShowcaseCar> showcaseCars = [
  ShowcaseCar(
    name: 'BMW M4',
    tagline: 'Competition Coupé',
    image: 'assets/images/campbell-3ZUsNJhi_Ik-unsplash.jpg',
    category: 'Sport',
    pricePerDay: 1500,
    rating: 4.8,
    reviews: 120,
    seats: 4,
    transmission: 'Auto',
    fuel: 'Petrol',
    topSpeed: 250,
    power: '503 hp',
    description:
        'The BMW M4 blends track-bred precision with daily usability. A twin-turbo '
        'inline-six, razor-sharp handling and a driver-focused cockpit make every '
        'kilometre an event.',
  ),
  ShowcaseCar(
    name: 'Mercedes-AMG GT',
    tagline: 'Grand Tourer',
    image: 'assets/images/joshua-koblin-eqW1MPinEV4-unsplash.jpg',
    category: 'Luxury',
    pricePerDay: 1800,
    rating: 4.9,
    reviews: 98,
    seats: 2,
    transmission: 'Auto',
    fuel: 'Petrol',
    topSpeed: 315,
    power: '577 hp',
    description:
        'A handcrafted AMG V8 wrapped in sculpted aluminium. The Mercedes-AMG GT '
        'delivers spine-tingling acceleration with the comfort and craftsmanship of '
        'a true grand tourer.',
  ),
  ShowcaseCar(
    name: 'Audi R8',
    tagline: 'V10 Supercar',
    image: 'assets/images/peter-broomfield-m3m-lnR90uM-unsplash.jpg',
    category: 'Sport',
    pricePerDay: 2500,
    rating: 4.7,
    reviews: 75,
    seats: 2,
    transmission: 'Auto',
    fuel: 'Petrol',
    topSpeed: 330,
    power: '562 hp',
    description:
        'A naturally aspirated V10 mounted mid-ship, quattro all-wheel drive and '
        'supercar presence. The Audi R8 is everyday-usable theatre on four wheels.',
  ),
];

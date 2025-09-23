// class Aspect {
//   final int id;
//   final String name;
//   final int hexColor;
//   final List<SubAspect> subAspects;

//   const Aspect({
//     required this.id,
//     required this.name,
//     required this.hexColor,
//     required this.subAspects,
//   });
// }

// class SubAspect {
//   final int id;
//   final String name;
//   final List<Category> categories;

//   const SubAspect({
//     required this.id,
//     required this.name,
//     required this.categories,
//   });
// }

// class Category {
//   final int id;
//   final String name;

//   const Category({
//     required this.id,
//     required this.name,
//   });
// }

// class AspectData {
//   static const List<Aspect> aspects = [
//     Aspect(
//       id: 1,
//       name: 'Culture & Heritage',
//       hexColor: 0xFFFFFFFF,
//       subAspects: [
//         SubAspect(
//           id: 1,
//           name: 'Cultural Hub',
//           categories: [
//             Category(id: 1, name: 'Museums'),
//             Category(id: 2, name: 'Community cultural centers'),
//             Category(id: 3, name: 'Theaters and cinemas'),
//             Category(id: 4, name: 'Public libraries'),
//             Category(id: 5, name: 'Art galleries'),
//             Category(id: 6, name: 'Traditional handicraft centers'),
//           ],
//         ),
//         SubAspect(
//           id: 2,
//           name: 'Identity',
//           categories: [
//             Category(id: 7, name: 'Local languages and dialects'),
//             Category(id: 8, name: 'National and local symbols'),
//             Category(id: 9, name: 'Traditional clothing'),
//             Category(id: 10, name: 'Distinct customs and traditions'),
//             Category(id: 11, name: 'Visual identity of the city'),
//             Category(id: 12, name: 'Local literature and arts'),
//           ],
//         ),
//         SubAspect(
//           id: 3,
//           name: 'Layers of the City',
//           categories: [
//             Category(id: 13, name: 'Old city'),
//             Category(id: 14, name: 'Historical neighborhoods'),
//             Category(id: 15, name: 'Sequential urban expansions'),
//             Category(id: 16, name: 'Old industrial areas'),
//             Category(id: 17, name: 'Various residential areas'),
//             Category(id: 18, name: 'Modern urban developments'),
//           ],
//         ),
//         SubAspect(
//           id: 4,
//           name: 'Tangible Heritage',
//           categories: [
//             Category(id: 19, name: 'Historical buildings'),
//             Category(id: 20, name: 'Archaeological sites'),
//             Category(id: 21, name: 'Monuments'),
//             Category(id: 22, name: 'Museum artifacts'),
//             Category(id: 23, name: 'Historical documents and manuscripts'),
//             Category(id: 24, name: 'Handicrafts and traditional products'),
//           ],
//         ),
//         SubAspect(
//           id: 5,
//           name: 'Intangible Heritage',
//           categories: [
//             Category(id: 25, name: 'Traditional music and singing'),
//             Category(id: 26, name: 'Folk dances'),
//             Category(id: 27, name: 'Local stories and legends'),
//             Category(id: 28, name: 'Traditional festivals and celebrations'),
//             Category(id: 29, name: 'Traditional culinary arts'),
//             Category(id: 30, name: 'Traditional knowledge and practices'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 2,
//       name: 'Building Code & Policy',
//       hexColor: 0xFFFFEB3B,
//       subAspects: [
//         SubAspect(
//           id: 6,
//           name: 'Ownership Rights',
//           categories: [
//             Category(id: 31, name: 'Property deeds'),
//             Category(id: 32, name: 'Easement rights'),
//             Category(id: 33, name: 'Joint ownership'),
//             Category(id: 34, name: 'Leasing rights'),
//             Category(id: 35, name: 'Expropriation laws for public benefit'),
//             Category(id: 36, name: 'Land and real estate registration'),
//           ],
//         ),
//         SubAspect(
//           id: 7,
//           name: 'Safety Standards',
//           categories: [
//             Category(id: 37, name: 'Fire alarm and protection systems'),
//             Category(id: 38, name: 'Emergency exits'),
//             Category(id: 39, name: 'Earthquake resistance standards'),
//             Category(id: 40, name: 'Flood protection systems'),
//             Category(id: 41, name: 'Electrical safety standards'),
//             Category(id: 42, name: 'Building monitoring systems'),
//           ],
//         ),
//         SubAspect(
//           id: 8,
//           name: 'Structural Integrity',
//           categories: [
//             Category(id: 43, name: 'Foundation design standards'),
//             Category(id: 44, name: 'Structural framework requirements'),
//             Category(id: 45, name: 'Construction material testing'),
//             Category(id: 46, name: 'Durability and load-bearing standards'),
//             Category(id: 47, name: 'Periodic safety inspections'),
//             Category(id: 48, name: 'Existing building assessments'),
//           ],
//         ),
//         SubAspect(
//           id: 9,
//           name: 'Energy & Materials Efficiency',
//           categories: [
//             Category(id: 49, name: 'Thermal insulation'),
//             Category(id: 50, name: 'Efficient heating and cooling systems'),
//             Category(id: 51, name: 'Use of sustainable building materials'),
//             Category(id: 52, name: 'Energy consumption standards'),
//             Category(id: 53, name: 'Renewable energy systems'),
//             Category(id: 54, name: 'Recycling construction materials'),
//           ],
//         ),
//         SubAspect(
//           id: 10,
//           name: 'Accessibility & Inclusivity',
//           categories: [
//             Category(id: 55, name: 'Ramps and elevators'),
//             Category(id: 56, name: 'Restrooms for people with disabilities'),
//             Category(id: 57, name: 'Braille signage and audio signals'),
//             Category(id: 58, name: 'Wheelchair-accessible paths and spaces'),
//             Category(id: 59, name: 'Universal design standards'),
//             Category(id: 60, name: 'Accessible transportation systems'),
//           ],
//         ),
//         SubAspect(
//           id: 11,
//           name: 'Health & Sanitation',
//           categories: [
//             Category(id: 61, name: 'Ventilation systems'),
//             Category(id: 62, name: 'Water treatment'),
//             Category(id: 63, name: 'Waste disposal'),
//             Category(id: 64, name: 'Pest control'),
//             Category(id: 65, name: 'Hygiene standards'),
//             Category(id: 66, name: 'Sewage systems'),
//           ],
//         ),
//         SubAspect(
//           id: 12,
//           name: 'Adaptability & Resilience',
//           categories: [
//             Category(id: 67, name: 'Flexible and modifiable designs'),
//             Category(id: 68, name: 'Resistance to extreme climate conditions'),
//             Category(id: 69, name: 'Adaptability to population changes'),
//             Category(id: 70, name: 'Versatile usage and reuse'),
//             Category(id: 71, name: 'Emergency response capabilities'),
//             Category(id: 72, name: 'Sustainable construction technologies'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 3,
//       name: 'Economic Factor',
//       hexColor: 0xFFF44336,
//       subAspects: [
//         SubAspect(
//           id: 13,
//           name: 'International Aid',
//           categories: [
//             Category(id: 73, name: 'International grants and loans'),
//             Category(id: 74, name: 'Humanitarian aid programs'),
//             Category(
//                 id: 75, name: 'Internationally funded development projects'),
//             Category(id: 76, name: 'International NGOs'),
//             Category(id: 77, name: 'Economic cooperation agreements'),
//             Category(id: 78, name: 'Reconstruction programs'),
//           ],
//         ),
//         SubAspect(
//           id: 14,
//           name: 'Employment Development',
//           categories: [
//             Category(id: 79, name: 'Vocational training programs'),
//             Category(id: 80, name: 'Business incubators'),
//             Category(id: 81, name: 'Employment centers'),
//             Category(id: 82, name: 'Small enterprise support programs'),
//             Category(id: 83, name: 'Local employment policies'),
//             Category(id: 84, name: 'Labor market qualification programs'),
//           ],
//         ),
//         SubAspect(
//           id: 15,
//           name: 'Economic Diversification',
//           categories: [
//             Category(id: 85, name: 'Diverse economic sectors'),
//             Category(id: 86, name: 'Manufacturing industries'),
//             Category(id: 87, name: 'Service sector'),
//             Category(id: 88, name: 'Digital economy'),
//             Category(id: 89, name: 'Creative industries'),
//             Category(id: 90, name: 'Green economy'),
//           ],
//         ),
//         SubAspect(
//           id: 16,
//           name: 'Tourism',
//           categories: [
//             Category(id: 91, name: 'Tourist sites'),
//             Category(id: 92, name: 'Tourism infrastructure'),
//             Category(id: 93, name: 'Accommodation services'),
//             Category(id: 94, name: 'Tourism promotion'),
//             Category(id: 95, name: 'Cultural tourism'),
//             Category(id: 96, name: 'Eco-tourism'),
//           ],
//         ),
//         SubAspect(
//           id: 17,
//           name: 'Financial Insecurity',
//           categories: [
//             Category(id: 97, name: 'Social safety nets'),
//             Category(id: 98, name: 'Poverty alleviation programs'),
//             Category(id: 99, name: 'Social insurance'),
//             Category(id: 100, name: 'Financial counseling services'),
//             Category(id: 101, name: 'Economic support for families'),
//             Category(id: 102, name: 'Microcredit systems'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 4,
//       name: 'Public Health',
//       hexColor: 0xFF4CAF50,
//       subAspects: [
//         SubAspect(
//           id: 18,
//           name: 'Health Care System',
//           categories: [
//             Category(id: 103, name: 'Hospitals'),
//             Category(id: 104, name: 'Primary health centers'),
//             Category(id: 105, name: 'Specialized clinics'),
//             Category(id: 106, name: 'Emergency services'),
//             Category(id: 107, name: 'Health insurance system'),
//             Category(id: 108, name: 'Medical and nursing staff'),
//           ],
//         ),
//         SubAspect(
//           id: 19,
//           name: 'Physical Health & Disability',
//           categories: [
//             Category(id: 109, name: 'Rehabilitation centers'),
//             Category(id: 110, name: 'Physical therapy services'),
//             Category(id: 111, name: 'Assistive and prosthetic devices'),
//             Category(id: 112, name: 'Therapeutic sports programs'),
//             Category(id: 113, name: 'Home care services'),
//             Category(id: 114, name: 'Disability support centers'),
//           ],
//         ),
//         SubAspect(
//           id: 20,
//           name: 'Disease Management',
//           categories: [
//             Category(id: 115, name: 'Infectious disease control programs'),
//             Category(id: 116, name: 'Epidemiological monitoring systems'),
//             Category(id: 117, name: 'Vaccination campaigns'),
//             Category(id: 118, name: 'Chronic disease management programs'),
//             Category(id: 119, name: 'Diagnostic laboratories'),
//             Category(id: 120, name: 'Treatment protocols'),
//           ],
//         ),
//         SubAspect(
//           id: 21,
//           name: 'Nutrition',
//           categories: [
//             Category(id: 121, name: 'Nutritional awareness programs'),
//             Category(id: 122, name: 'Nutritional counseling centers'),
//             Category(id: 123, name: 'School nutrition programs'),
//             Category(id: 124, name: 'Food quality monitoring'),
//             Category(id: 125, name: 'Malnutrition prevention programs'),
//             Category(id: 126, name: 'Food security'),
//           ],
//         ),
//         SubAspect(
//           id: 22,
//           name: 'Medication',
//           categories: [
//             Category(id: 127, name: 'Pharmacies'),
//             Category(id: 128, name: 'Drug warehouses'),
//             Category(id: 129, name: 'Medicine distribution systems'),
//             Category(id: 130, name: 'Pharmaceutical regulation'),
//             Category(id: 131, name: 'Medicine support programs'),
//             Category(id: 132, name: 'Local pharmaceutical industry'),
//           ],
//         ),
//         SubAspect(
//           id: 23,
//           name: 'Psych & Mental Health',
//           categories: [
//             Category(id: 133, name: 'Mental health centers'),
//             Category(id: 134, name: 'Psychological counseling services'),
//             Category(id: 135, name: 'Mental support programs'),
//             Category(id: 136, name: 'Addiction treatment centers'),
//             Category(id: 137, name: 'Mental health awareness programs'),
//             Category(id: 138, name: 'Psychiatric emergency services'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 5,
//       name: 'Resources Management',
//       hexColor: 0xFF2196F3,
//       subAspects: [
//         SubAspect(
//           id: 24,
//           name: 'Capacity Building',
//           categories: [
//             Category(id: 139, name: 'Training centers'),
//             Category(id: 140, name: 'Skills development programs'),
//             Category(id: 141, name: 'Knowledge and experience transfer'),
//             Category(id: 142, name: 'Local leadership development'),
//             Category(id: 143, name: 'Continuing education programs'),
//             Category(id: 144, name: 'Professional collaboration networks'),
//           ],
//         ),
//         SubAspect(
//           id: 25,
//           name: 'Water Resources',
//           categories: [
//             Category(id: 145, name: 'Water sources'),
//             Category(id: 146, name: 'Water treatment plants'),
//             Category(id: 147, name: 'Water distribution networks'),
//             Category(id: 148, name: 'Water storage systems'),
//             Category(id: 149, name: 'Rainwater management'),
//             Category(id: 150, name: 'Water conservation technologies'),
//           ],
//         ),
//         SubAspect(
//           id: 26,
//           name: 'Food Insecurity',
//           categories: [
//             Category(id: 151, name: 'Food banks'),
//             Category(id: 152, name: 'Food assistance programs'),
//             Category(id: 153, name: 'Urban farming projects'),
//             Category(id: 154, name: 'Food distribution systems'),
//             Category(id: 155, name: 'Hunger prevention programs'),
//             Category(id: 156, name: 'Monitoring food prices'),
//           ],
//         ),
//         SubAspect(
//           id: 27,
//           name: 'Material Resources',
//           categories: [
//             Category(id: 157, name: 'Raw material sources'),
//             Category(id: 158, name: 'Supply chains'),
//             Category(id: 159, name: 'Storage and distribution centers'),
//             Category(id: 160, name: 'Material recycling'),
//             Category(id: 161, name: 'Inventory management'),
//             Category(id: 162, name: 'Efficient resource use technologies'),
//           ],
//         ),
//         SubAspect(
//           id: 28,
//           name: 'Energy Resources',
//           categories: [
//             Category(id: 163, name: 'Power generation plants'),
//             Category(
//                 id: 164, name: 'Energy transmission and distribution networks'),
//             Category(id: 165, name: 'Renewable energy sources'),
//             Category(id: 166, name: 'Energy storage systems'),
//             Category(id: 167, name: 'Energy efficiency'),
//             Category(id: 168, name: 'Energy demand management'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 6,
//       name: 'Urban Planning',
//       hexColor: 0xFFFF9800,
//       subAspects: [
//         SubAspect(
//           id: 29,
//           name: 'Public Spaces',
//           categories: [
//             Category(id: 169, name: 'Squares and plazas'),
//             Category(id: 170, name: 'Parks and gardens'),
//             Category(id: 171, name: 'Public beaches'),
//             Category(id: 172, name: 'Recreational areas'),
//             Category(id: 173, name: 'Sidewalks and walkways'),
//             Category(id: 174, name: 'Multi-use open spaces'),
//           ],
//         ),
//         SubAspect(
//           id: 30,
//           name: 'Amenities',
//           categories: [
//             Category(id: 175, name: 'Sports facilities'),
//             Category(id: 176, name: 'Recreational amenities'),
//             Category(id: 177, name: 'Cultural amenities'),
//             Category(id: 178, name: 'Educational facilities'),
//             Category(id: 179, name: 'Health facilities'),
//             Category(id: 180, name: 'Malls and marketplaces'),
//           ],
//         ),
//         SubAspect(
//           id: 31,
//           name: 'Housing & Buildings',
//           categories: [
//             Category(id: 181, name: 'Residential units'),
//             Category(id: 182, name: 'Commercial buildings'),
//             Category(id: 183, name: 'Industrial buildings'),
//             Category(id: 184, name: 'Government buildings'),
//             Category(id: 185, name: 'Educational buildings'),
//             Category(id: 186, name: 'Mixed-use buildings'),
//           ],
//         ),
//         SubAspect(
//           id: 32,
//           name: 'Population',
//           categories: [
//             Category(id: 187, name: 'Population distribution'),
//             Category(id: 188, name: 'Population density'),
//             Category(id: 189, name: 'Age structure'),
//             Category(id: 190, name: 'Social and cultural diversity'),
//             Category(id: 191, name: 'Population growth rates'),
//             Category(id: 192, name: 'Internal migration'),
//           ],
//         ),
//         SubAspect(
//           id: 33,
//           name: 'Land Use',
//           categories: [
//             Category(id: 193, name: 'Residential zones'),
//             Category(id: 194, name: 'Commercial zones'),
//             Category(id: 195, name: 'Industrial zones'),
//             Category(id: 196, name: 'Agricultural zones'),
//             Category(id: 197, name: 'Recreational zones'),
//             Category(id: 198, name: 'Protected areas'),
//           ],
//         ),
//         SubAspect(
//           id: 34,
//           name: 'Infrastructure',
//           categories: [
//             Category(id: 199, name: 'Water networks'),
//             Category(id: 200, name: 'Sewage systems'),
//             Category(id: 201, name: 'Electricity grids'),
//             Category(id: 202, name: 'Telecommunications networks'),
//             Category(id: 203, name: 'Waste management'),
//             Category(id: 204, name: 'Dams and bridges'),
//           ],
//         ),
//         SubAspect(
//           id: 35,
//           name: 'Urban Transformation',
//           categories: [
//             Category(id: 205, name: 'Rehabilitation of deteriorated areas'),
//             Category(id: 206, name: 'Urban center renewal'),
//             Category(id: 207, name: 'Repurposing old industrial zones'),
//             Category(id: 208, name: 'Planned urban expansion'),
//             Category(id: 209, name: 'Urban densification'),
//             Category(id: 210, name: 'Major urban projects'),
//           ],
//         ),
//         SubAspect(
//           id: 36,
//           name: 'Network & Mobility',
//           categories: [
//             Category(id: 211, name: 'Road networks'),
//             Category(id: 212, name: 'Public transport'),
//             Category(id: 213, name: 'Bicycle lanes'),
//             Category(id: 214, name: 'Pedestrian paths'),
//             Category(id: 215, name: 'Transport stations'),
//             Category(id: 216, name: 'Intelligent transportation systems'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 7,
//       name: 'Data Collection & Analysis',
//       hexColor: 0xFF2196F3,
//       subAspects: [
//         SubAspect(
//           id: 37,
//           name: 'Official Statistics',
//           categories: [
//             Category(id: 217, name: 'Population census'),
//             Category(id: 218, name: 'Economic surveys'),
//             Category(id: 219, name: 'Education statistics'),
//             Category(id: 220, name: 'Health statistics'),
//             Category(id: 221, name: 'Labor statistics'),
//             Category(id: 222, name: 'Environmental statistics'),
//           ],
//         ),
//         SubAspect(
//           id: 38,
//           name: 'Research Tools',
//           categories: [
//             Category(id: 223, name: 'Questionnaires'),
//             Category(id: 224, name: 'Interviews'),
//             Category(id: 225, name: 'Focus groups'),
//             Category(id: 226, name: 'Monitoring and surveillance tools'),
//             Category(id: 227, name: 'Statistical data analysis'),
//             Category(id: 228, name: 'Simulation models'),
//           ],
//         ),
//         SubAspect(
//           id: 39,
//           name: 'Mapping Tools',
//           categories: [
//             Category(id: 229, name: 'Geographic Information Systems (GIS)'),
//             Category(id: 230, name: 'Remote sensing'),
//             Category(id: 231, name: 'Satellite imagery'),
//             Category(id: 232, name: 'Participatory community mapping'),
//             Category(id: 233, name: 'Heat maps'),
//             Category(id: 234, name: 'Spatial data visualization'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 8,
//       name: 'Technology & Digital Infrastructure',
//       hexColor: 0xFF9C27B0,
//       subAspects: [
//         SubAspect(
//           id: 40,
//           name: 'Social Networking',
//           categories: [
//             Category(id: 235, name: 'Social media platforms'),
//             Category(id: 236, name: 'Virtual community groups'),
//             Category(id: 237, name: 'Information-sharing platforms'),
//             Category(id: 238, name: 'Professional collaboration networks'),
//             Category(id: 239, name: 'Community participation platforms'),
//             Category(id: 240, name: 'Digital communication tools'),
//           ],
//         ),
//         SubAspect(
//           id: 41,
//           name: 'Online Platforms',
//           categories: [
//             Category(id: 241, name: 'E-learning platforms'),
//             Category(id: 242, name: 'E-commerce platforms'),
//             Category(id: 243, name: 'E-government service platforms'),
//             Category(id: 244, name: 'Remote work platforms'),
//             Category(id: 245, name: 'E-health platforms'),
//             Category(id: 246, name: 'Civic engagement platforms'),
//           ],
//         ),
//         SubAspect(
//           id: 42,
//           name: 'Hi-Technology & AI',
//           categories: [
//             Category(id: 247, name: 'Artificial intelligence applications'),
//             Category(id: 248, name: 'Internet of Things (IoT)'),
//             Category(id: 249, name: 'Robotics'),
//             Category(id: 250, name: 'Virtual and augmented reality'),
//             Category(id: 251, name: 'Big data and analytics'),
//             Category(id: 252, name: 'Smart city systems'),
//           ],
//         ),
//         SubAspect(
//           id: 43,
//           name: 'Digital Connectivity',
//           categories: [
//             Category(id: 253, name: 'Internet networks'),
//             Category(id: 254, name: 'Mobile networks'),
//             Category(id: 255, name: 'Data centers'),
//             Category(id: 256, name: 'Public internet access points'),
//             Category(id: 257, name: 'Fiber optic infrastructure'),
//             Category(id: 258, name: 'Wireless network coverage'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 9,
//       name: 'Ecological Factor',
//       hexColor: 0xFF4CAF50,
//       subAspects: [
//         SubAspect(
//           id: 44,
//           name: 'Green Spaces',
//           categories: [
//             Category(id: 259, name: 'Public gardens'),
//             Category(id: 260, name: 'Urban forests'),
//             Category(id: 261, name: 'Green belts'),
//             Category(id: 262, name: 'Urban agriculture'),
//             Category(id: 263, name: 'Green roofs and walls'),
//             Category(id: 264, name: 'Ecological corridors'),
//           ],
//         ),
//         SubAspect(
//           id: 45,
//           name: 'Waste Management',
//           categories: [
//             Category(id: 265, name: 'Waste collection centers'),
//             Category(id: 266, name: 'Waste sorting stations'),
//             Category(id: 267, name: 'Recycling facilities'),
//             Category(id: 268, name: 'Organic waste treatment plants'),
//             Category(id: 269, name: 'Sanitary landfills'),
//             Category(id: 270, name: 'Waste reduction programs'),
//           ],
//         ),
//         SubAspect(
//           id: 46,
//           name: 'Water & Air Quality',
//           categories: [
//             Category(id: 271, name: 'Air quality monitoring stations'),
//             Category(id: 272, name: 'Water quality monitoring systems'),
//             Category(id: 273, name: 'Air pollution treatment technologies'),
//             Category(id: 274, name: 'Water source protection programs'),
//             Category(id: 275, name: 'Emission reduction policies'),
//             Category(id: 276, name: 'Low-emission zones'),
//           ],
//         ),
//         SubAspect(
//           id: 47,
//           name: 'Climate',
//           categories: [
//             Category(id: 277, name: 'Early warning systems for climate events'),
//             Category(id: 278, name: 'Climate change adaptation strategies'),
//             Category(id: 279, name: 'Carbon emissions reduction initiatives'),
//             Category(id: 280, name: 'Climate-conscious building design'),
//             Category(id: 281, name: 'Urban heat islands'),
//             Category(id: 282, name: 'Climate-responsive urban planning'),
//           ],
//         ),
//         SubAspect(
//           id: 48,
//           name: 'Natural Disaster',
//           categories: [
//             Category(id: 283, name: 'Early warning systems'),
//             Category(id: 284, name: 'Emergency response plans'),
//             Category(id: 285, name: 'Disaster-resilient infrastructure'),
//             Category(id: 286, name: 'Shelters'),
//             Category(id: 287, name: 'Rescue and emergency teams'),
//             Category(id: 288, name: 'Post-disaster recovery programs'),
//           ],
//         ),
//         SubAspect(
//           id: 49,
//           name: 'Agriculture',
//           categories: [
//             Category(id: 289, name: 'Agricultural lands'),
//             Category(id: 290, name: 'Irrigation systems'),
//             Category(id: 291, name: 'Greenhouses'),
//             Category(id: 292, name: 'Organic farming'),
//             Category(id: 293, name: 'Seed banks'),
//             Category(id: 294, name: 'Sustainable agriculture'),
//           ],
//         ),
//       ],
//     ),
//     Aspect(
//       id: 10,
//       name: 'Social Factor',
//       hexColor: 0xFFF44336,
//       subAspects: [
//         SubAspect(
//           id: 50,
//           name: 'Civil Peace',
//           categories: [
//             Category(id: 295, name: 'Conflict resolution mechanisms'),
//             Category(id: 296, name: 'Community peacebuilding programs'),
//             Category(id: 297, name: 'Community dialogue initiatives'),
//             Category(id: 298, name: 'Community justice systems'),
//             Category(id: 299, name: 'Social cohesion programs'),
//             Category(id: 300, name: 'Community safety nets'),
//           ],
//         ),
//         SubAspect(
//           id: 51,
//           name: 'Immigration',
//           categories: [
//             Category(id: 301, name: 'Migrant reception services'),
//             Category(id: 302, name: 'Integration programs'),
//             Category(id: 303, name: 'Translation and communication services'),
//             Category(id: 304, name: 'Legal assistance centers'),
//             Category(id: 305, name: 'Language training programs'),
//             Category(id: 306, name: 'Migrant support networks'),
//           ],
//         ),
//         SubAspect(
//           id: 52,
//           name: 'Local Community',
//           categories: [
//             Category(id: 307, name: 'Local councils'),
//             Category(id: 308, name: 'Civil society organizations'),
//             Category(id: 309, name: 'Community initiatives'),
//             Category(id: 310, name: 'Community support networks'),
//             Category(id: 311, name: 'Community centers'),
//             Category(id: 312, name: 'Community events'),
//           ],
//         ),
//         SubAspect(
//           id: 53,
//           name: 'Adaptation',
//           categories: [
//             Category(id: 313, name: 'Adaptation programs to changes'),
//             Category(id: 314, name: 'Psychosocial support services'),
//             Category(
//                 id: 315, name: 'Community resilience-building initiatives'),
//             Category(id: 316, name: 'Solidarity networks'),
//             Category(id: 317, name: 'Rehabilitation programs'),
//             Category(id: 318, name: 'Community adaptation strategies'),
//           ],
//         ),
//         SubAspect(
//           id: 54,
//           name: 'Education System',
//           categories: [
//             Category(id: 319, name: 'Schools'),
//             Category(id: 320, name: 'Universities and colleges'),
//             Category(id: 321, name: 'Vocational training centers'),
//             Category(id: 322, name: 'Continuing education institutions'),
//             Category(id: 323, name: 'Educational libraries'),
//             Category(id: 324, name: 'Research centers'),
//           ],
//         ),
//         SubAspect(
//           id: 55,
//           name: 'Community Engagement',
//           categories: [
//             Category(id: 325, name: 'Public participation platforms'),
//             Category(id: 326, name: 'Volunteering programs'),
//             Category(id: 327, name: 'Community work initiatives'),
//             Category(id: 328, name: 'Community dialogue forums'),
//             Category(id: 329, name: 'Public consultation mechanisms'),
//             Category(id: 330, name: 'Community development projects'),
//           ],
//         ),
//       ],
//     ),
//   ];

//   static List<Aspect> getAspects() {
//     return aspects;
//   }

//   static List<SubAspect> getSubAspectsForAspect(int aspectId) {
//     final aspect = getAspectById(aspectId);
//     return aspect?.subAspects ?? [];
//   }

//   static List<Category> getCategoriesForSubAspect(int subAspectId) {
//     final subAspect = getSubAspectById(subAspectId);
//     return subAspect?.categories ?? [];
//   }

//   static Aspect? getAspectById(int id) {
//     try {
//       return aspects.firstWhere((aspect) => aspect.id == id);
//     } catch (e) {
//       return null;
//     }
//   }

//   static SubAspect? getSubAspectById(int id) {
//     for (var aspect in aspects) {
//       try {
//         print(
//             "gg : aspect.subAspects.firstWhere((subAspect) => subAspect.id == id");
//         return aspect.subAspects.firstWhere((subAspect) => subAspect.id == id);
//       } catch (e) {
//         continue;
//       }
//     }
//     return null;
//   }

//   static Category? getCategoryById(int id) {
//     for (var aspect in aspects) {
//       for (var subAspect in aspect.subAspects) {
//         try {
//           return subAspect.categories
//               .firstWhere((category) => category.id == id);
//         } catch (e) {
//           continue;
//         }
//       }
//     }
//     return null;
//   }
// }

class AspectModel2 {
  final int id;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  AspectModel2({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory AspectModel2.fromJson(Map<String, dynamic> json) {
    return AspectModel2(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Set EJS as template engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static('public'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Sample parts data
const parts = [
  {
    id: 1,
    name: "Mercedes-Benz Brake Pads Set",
    price: 189.99,
    category: "Brakes",
    image: "/api/placeholder/300/200",
    description: "High-performance brake pads for optimal stopping power",
    compatibility: ["C-Class", "E-Class", "S-Class"]
  },
  {
    id: 2,
    name: "Original Air Filter",
    price: 45.50,
    category: "Engine",
    image: "/api/placeholder/300/200",
    description: "Genuine Mercedes-Benz air filter for improved engine performance",
    compatibility: ["A-Class", "C-Class", "GLC"]
  },
  {
    id: 3,
    name: "LED Headlight Assembly",
    price: 429.99,
    category: "Lighting",
    image: "/api/placeholder/300/200",
    description: "Original LED headlight with adaptive highbeam assist",
    compatibility: ["E-Class", "S-Class", "GLE"]
  },
  {
    id: 4,
    name: "Transmission Fluid",
    price: 32.99,
    category: "Fluids",
    image: "/api/placeholder/300/200",
    description: "Premium transmission fluid for smooth gear shifts",
    compatibility: ["All Models"]
  },
  {
    id: 5,
    name: "Wheel Bearing Kit",
    price: 156.75,
    category: "Suspension",
    image: "/api/placeholder/300/200",
    description: "Complete wheel bearing assembly kit",
    compatibility: ["C-Class", "E-Class", "CLS"]
  },
  {
    id: 6,
    name: "Spark Plug Set",
    price: 89.99,
    category: "Ignition",
    image: "/api/placeholder/300/200",
    description: "Iridium spark plugs for better fuel efficiency",
    compatibility: ["A-Class", "C-Class", "GLA"]
  }
];

// Routes
app.get('/', (req, res) => {
  res.render('index', { 
    title: 'Sealed-autos | Premium Mercedes Parts',
    parts: parts,
    company: 'Sealed-autos',
    ceo: 'Ozumba Johnpaul'
  });
});

app.get('/parts', (req, res) => {
  res.json(parts);
});

app.get('/parts/:id', (req, res) => {
  const part = parts.find(p => p.id === parseInt(req.params.id));
  if (!part) {
    return res.status(404).json({ error: 'Part not found' });
  }
  res.json(part);
});

app.get('/about', (req, res) => {
  res.render('about', {
    title: 'About Us - Sealed-autos',
    company: 'Sealed-autos',
    ceo: 'Ozumba Johnpaul'
  });
});

app.get('/contact', (req, res) => {
  res.render('contact', {
    title: 'Contact - Sealed-autos',
    company: 'Sealed-autos'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Sealed-autos server running on http://localhost:${PORT}`);
  console.log(`CEO: Ozumba Johnpaul`);
});
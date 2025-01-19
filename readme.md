# ITONICS Product Management Module for Drupal 7

A Drupal 7 module for managing products with features like categorization, image management, and rich text descriptions.

## Prerequisites

- Docker
- Docker Compose
- Git

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-name>
```

2. Create environment file:
```bash
cp .env.example .env
```

3. Configure your environment variables in `.env` file with appropriate values for:
- MYSQL_ROOT_PASSWORD
- MYSQL_DATABASE
- MYSQL_USER
- MYSQL_PASSWORD

4. Build and start the containers:
```bash
docker-compose up -d
```

5. Wait for the containers to be ready (this may take a few minutes on first run)

## Initial Drupal Setup

1. Access Drupal installation at `http://localhost`

2. Follow the Drupal installation wizard:
   - Choose "Standard" installation profile
   - Select English (or your preferred language)
   - For database configuration, use:
     - Database name: drupal
     - Database username: drupal
     - Database password: drupal
     - Advanced options > Host: database

3. Complete the site configuration form with your desired admin credentials

## Module Configuration

1. Enable required modules:
   - Go to `admin/modules`
   - Enable the following modules:
     - Date
     - Libraries
     - WYSIWYG
     - Image
     - SameerNyaupane ITONICS Products

2. Configure permissions:
   - Go to `admin/people/permissions`
   - Set appropriate permissions for:
     - Access product administration
     - Create products
     - Edit products
     - Delete products

## Usage

### Managing Products

- Access the product management interface at `admin/products`
- Add new products using the "Add Product" button
- Edit or delete existing products using the operations links
- Use the search and filter options to find specific products

### Product Features

- Image upload with multiple display styles
- Rich text editing for product descriptions
- Multi-select categorization
- Product type classification (Physical/Digital)
- Expiry date management
- Owner email assignment

## Development

### Project Structure

The module is located in:
```
modules/sameernyaupane_itonics_products/
```

Key files:
- `.module` - Main module file with hooks and functions
- `.install` - Database schema and installation hooks
- `css/` - Styling files
- `js/` - JavaScript functionality

### Docker Configuration

The project uses two containers:
- Drupal 7 with Apache (PHP 7.4)
- MySQL 5.7

Relevant configuration files:
- `Dockerfile` - PHP and Drupal configuration
- `docker-compose.yml` - Container orchestration
- `apache-config.conf` - Apache virtual host configuration

## Troubleshooting

1. If the site is not accessible:
```bash
docker-compose ps
docker-compose logs drupal
```

2. For database connection issues:
```bash
docker-compose logs database
```

3. To rebuild containers:
```bash
docker-compose down
docker-compose up -d --build
```

This README references several code files from the provided codebase:

1. Docker setup:

```1:17:docker-compose.yml
services:
  drupal:
    build: .
    ports:
      - "80:80"
    volumes:
      - ./modules:/var/www/html/sites/all/modules/custom
    depends_on:
      - database
  
  database:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL
```


2. Module installation:

```6:116:modules/sameernyaupane_itonics_products/sameernyaupane_itonics_products.install
function sameernyaupane_itonics_products_schema() {
  $schema['sameernyaupane_itonics_products'] = array(
    'description' => 'Stores product information',
    'fields' => array(
      'pid' => array(
        'description' => 'Primary identifier for a product',
        'type' => 'serial',
        'unsigned' => TRUE,
        'not null' => TRUE,
      ),
      'title' => array(
        'description' => 'Product title',
        'type' => 'varchar',
        'length' => 255,
        'not null' => TRUE,
      ),
      'image_fid' => array(
        'description' => 'File ID of the product image',
        'type' => 'int',
        'unsigned' => TRUE,
      ),
      'summary' => array(
        'description' => 'Product summary',
        'type' => 'text',
      ),
      'description' => array(
        'description' => 'Product description',
        'type' => 'text',
        'size' => 'big',
      ),
      'category' => array(
        'description' => 'Product categories',
        'type' => 'text',
      ),
      'type' => array(
        'description' => 'Product type',
        'type' => 'varchar',
        'length' => 50,
        'not null' => TRUE,
      ),
      'owner_email' => array(
        'description' => 'Product owner email',
        'type' => 'varchar',
        'length' => 255,
        'not null' => TRUE,
      ),
      'expiry_date' => array(
        'description' => 'Product expiry date',
        'type' => 'int',
        'not null' => FALSE,
      ),
      'created' => array(
        'description' => 'Creation timestamp',
        'type' => 'int',
        'not null' => TRUE,
      ),
    ),
    'primary key' => array('pid'),
  );
  
  return $schema;
}

/**
 * Implements hook_install().
 */
function sameernyaupane_itonics_products_install() {
  // Create image styles
  $styles = array(
    'product_thumbnail' => array(
      'effects' => array(
        array(
          'name' => 'image_scale_and_crop',
          'data' => array('width' => 100, 'height' => 100),
        ),
      ),
    ),
    'product_medium' => array(
      'effects' => array(
        array(
          'name' => 'image_scale',
          'data' => array('width' => 400, 'height' => NULL),
        ),
      ),
    ),
    'product_large' => array(
      'effects' => array(
        array(
          'name' => 'image_scale',
          'data' => array('width' => 800, 'height' => NULL),
        ),
      ),
    ),
    'product_grid' => array(
      'effects' => array(
        array(
          'name' => 'image_scale_and_crop',
          'data' => array('width' => 300, 'height' => 200),
        ),
      ),
    ),
  );
  
  foreach ($styles as $style_name => $style_data) {
    $style = image_style_save(array('name' => $style_name));
    foreach ($style_data['effects'] as $effect) {
      $effect['isid'] = $style['isid'];
      image_effect_save($effect);
    }
  }
} 
```


3. Module configuration:

```1:8:modules/sameernyaupane_itonics_products/sameernyaupane_itonics_products.info
name = SameerNyaupane ITONICS Products
description = Product management module for ITONICS
core = 7.x
package = Custom
dependencies[] = image
dependencies[] = date
dependencies[] = libraries
dependencies[] = wysiwyg 
```

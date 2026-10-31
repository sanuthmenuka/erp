{
    'name': 'QuickBite Base',
    'summary': 'Core restaurant configuration for QuickBite: outlets, order-type settings, security groups',
    'description': """
Foundation module for the QuickBite restaurant ERP.
Every other quickbite_* module depends on this one.
    """,
    'author': 'QuickBite',
    'category': 'Sales/Restaurant',
    # <odoo major>.<odoo minor>.<module major>.<module minor>.<patch>
    # Bump on EVERY change that touches models, data or views, and add a
    # migrations/<new version>/ script when existing data must be transformed.
    'version': '19.0.1.0.0',
    'depends': ['base', 'mail'],
    'data': [
        'security/quickbite_security.xml',
        'security/ir.model.access.csv',
        'views/quickbite_outlet_views.xml',
        'views/quickbite_menus.xml',
    ],
    'application': True,
    'installable': True,
    'license': 'LGPL-3',
}

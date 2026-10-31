from psycopg2 import IntegrityError

from odoo.tests import TransactionCase, tagged
from odoo.tools import mute_logger


@tagged('post_install', '-at_install')
class TestOutlet(TransactionCase):

    @classmethod
    def setUpClass(cls):
        super().setUpClass()
        cls.outlet = cls.env['quickbite.outlet'].create({'name': 'Colombo 07', 'code': 'CMB07'})

    def test_defaults(self):
        self.assertEqual(self.outlet.currency_id, self.env.company.currency_id)
        self.assertEqual(self.outlet.display_name, '[CMB07] Colombo 07')

    def test_code_unique(self):
        with mute_logger('odoo.sql_db'), self.assertRaises(IntegrityError), self.cr.savepoint():
            self.env['quickbite.outlet'].create({'name': 'Dup', 'code': 'CMB07'})

    def test_order_type_unique_per_outlet(self):
        Setting = self.env['quickbite.outlet.setting']
        Setting.create({'outlet_id': self.outlet.id, 'order_type': 'dinein'})
        with mute_logger('odoo.sql_db'), self.assertRaises(IntegrityError), self.cr.savepoint():
            Setting.create({'outlet_id': self.outlet.id, 'order_type': 'dinein'})

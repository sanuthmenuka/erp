from odoo import fields, models

ORDER_TYPES = [
    ('dinein', 'Dine-in'),
    ('takeaway', 'Takeaway'),
    ('uber', 'Uber Eats'),
    ('pickme', 'PickMe Food'),
]


class QuickbiteOutletSetting(models.Model):
    """Per-outlet, per-order-type configuration (table `outlet_setting`)."""

    _name = 'quickbite.outlet.setting'
    _description = 'Outlet Order Type Setting'
    _order = 'outlet_id, order_type'

    _outlet_order_type_uniq = models.Constraint(
        'UNIQUE (outlet_id, order_type)',
        'Each order type can only be configured once per outlet.',
    )

    outlet_id = fields.Many2one('quickbite.outlet', required=True, ondelete='cascade', index=True)
    currency_id = fields.Many2one(related='outlet_id.currency_id')
    order_type = fields.Selection(ORDER_TYPES, required=True)
    is_enabled = fields.Boolean(string='Enabled', default=True)
    tax_inclusive = fields.Boolean()
    service_charge_pct = fields.Float(string='Service Charge (%)', digits=(5, 2))
    packaging_charge = fields.Monetary(currency_field='currency_id')
    default_payment_window_seconds = fields.Integer(string='Payment Window (s)', default=900)

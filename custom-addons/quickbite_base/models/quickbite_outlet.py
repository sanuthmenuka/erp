from odoo import api, fields, models

from odoo.addons.base.models.res_partner import _tz_get


class QuickbiteOutlet(models.Model):
    """A physical restaurant location (docs/ROS_Data_Model.txt - table `outlet`)."""

    _name = 'quickbite.outlet'
    _description = 'Restaurant Outlet'
    _inherit = ['mail.thread']
    _order = 'name'

    _code_uniq = models.Constraint('UNIQUE (code)', 'Outlet code must be unique.')
    _service_charge_range = models.Constraint(
        'CHECK (service_charge_pct >= 0 AND service_charge_pct <= 100)',
        'Service charge must be between 0 and 100%.',
    )

    name = fields.Char(required=True, tracking=True)
    code = fields.Char(required=True, size=20, tracking=True, copy=False)
    active = fields.Boolean(default=True, tracking=True)
    company_id = fields.Many2one('res.company', required=True, default=lambda self: self.env.company)
    address = fields.Char()
    city = fields.Char()
    country_id = fields.Many2one('res.country')
    tz = fields.Selection(_tz_get, string='Timezone', default=lambda self: self.env.user.tz or 'UTC')
    currency_id = fields.Many2one(
        'res.currency', required=True, default=lambda self: self.env.company.currency_id,
    )
    lang = fields.Selection(selection='_get_lang_selection', string='Default Language')
    service_charge_pct = fields.Float(string='Service Charge (%)', digits=(5, 2), tracking=True)
    packaging_charge_default = fields.Monetary(currency_field='currency_id', tracking=True)
    setting_ids = fields.One2many('quickbite.outlet.setting', 'outlet_id', string='Order Type Settings')

    @api.model
    def _get_lang_selection(self):
        return self.env['res.lang'].get_installed()

    @api.depends('code', 'name')
    def _compute_display_name(self):
        for outlet in self:
            outlet.display_name = f'[{outlet.code}] {outlet.name}' if outlet.code else outlet.name

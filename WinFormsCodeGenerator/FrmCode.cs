namespace WinFormsCodeGenerator
{
    public partial class FrmCode : Form
    {
        public FrmCode(string code, string? frmTitle = null)
        {
            InitializeComponent();
            if (frmTitle != null)
            {
                Text = frmTitle;
            }

            txtCode.Text = code;
        }
    }
}
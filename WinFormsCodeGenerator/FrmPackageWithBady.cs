using WinFormsCodeGenerator.CustomClass;

namespace WinFormsCodeGenerator
{
    public partial class FrmPackageWithBady : Form
    {
        public FrmPackageWithBady()
        {
            InitializeComponent();
            MaximizeBox = false;

            FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
        }

        public List<OraDbObjects> listOraDbObjects = new();

        private void btnGeneratCode_Click(object sender, EventArgs e)
        {
            string packageBadyCodeVal = "";
            string packageCodeVal = "";
            string packageCodeValQry = "";
            string packageBodyCodeValQry = "";
            Package package = new();
            PackageQry packageQry = new();
            PackageBady packageBady = new();
            PackageBadyQry packageBadyQry = new();

            ReadDataGrid();

            if (listOraDbObjects!.Any())
            {
                packageCodeVal = package.GeneratePackage(txtSchemaName.Text.Trim().ToUpper(), txtPackageName.Text.Trim().ToUpper(),
                                                              txtTableName.Text.Trim().ToUpper(), txtMsgTitle.Text.Trim().ToUpper(),
                                                              listOraDbObjects);

                packageBadyCodeVal = packageBady.GeneratePackage(txtSchemaName.Text.Trim().ToUpper(), txtPackageName.Text.Trim().ToUpper(),
                                                              txtTableName.Text.Trim().ToUpper(), txtMsgTitle.Text.Trim().ToUpper(),
                                                              listOraDbObjects);

                packageCodeValQry = packageQry.GeneratePackage(txtSchemaName.Text.Trim().ToUpper(), txtPackageName.Text.Trim().ToUpper(),
                                                              txtTableName.Text.Trim().ToUpper(), txtMsgTitle.Text.Trim().ToUpper(),
                                                              listOraDbObjects);

                packageBodyCodeValQry = packageBadyQry.GeneratePackage(txtSchemaName.Text.Trim().ToUpper(), txtPackageName.Text.Trim().ToUpper(),
                                                              txtTableName.Text.Trim().ToUpper(), txtMsgTitle.Text.Trim().ToUpper(),
                                                              listOraDbObjects);
            }

            string allPackageCodeVal = packageCodeVal + " \n\n\n" + packageBadyCodeVal;
            FrmCode packageBadyFrmCode = new(packageCodeValQry + "\n\n" + packageBodyCodeValQry, "PackageQry List/Details Code ");
            FrmCode allPackageFrmCode = new(allPackageCodeVal, "Package CRUD Code");

            allPackageFrmCode.Show();
            packageBadyFrmCode.Show();
        }

        public void ReadDataGrid()
        {
            listOraDbObjects.Clear();
            try
            {
                foreach (DataGridViewRow row in dataGridView1.Rows)
                {
                    OraDbObjects oraDbObjects = new();

                    if (row.Cells[0].Value != null)
                    {
                        oraDbObjects.ColName = row.Cells[0].Value.ToString();
                    }
                    else
                    {
                        break;
                    }

                    if (row.Cells[1].Value != null)
                    {
                        oraDbObjects.ColType = row.Cells[1].Value.ToString();
                    }

                    if (row.Cells[2].Value != null)
                    {
                        oraDbObjects.ColLenth = row.Cells[2].Value.ToString();
                    }

                    if (row.Cells[3].Value != null)
                    {
                        oraDbObjects.ColNullable = row.Cells[3].Value.ToString();
                    }
                    if (row.Cells[4].Value != null)
                    {
                        oraDbObjects.ColDefauldVal = row.Cells[4].Value.ToString();
                    }
                    if (row.Cells[5].Value != null)
                    {
                        oraDbObjects.ColKeyName = row.Cells[5].Value.ToString();
                    }

                    listOraDbObjects.Add(oraDbObjects);
                }
            }
            catch (Exception ex)
            {
                _ = MessageBox.Show(ex.Message);
            }
        }
    }
}
namespace WinFormsCodeGenerator
{
    partial class FrmPackageWithBady
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle();
            this.dataGridView1 = new System.Windows.Forms.DataGridView();
            this.COLUMN_NAME = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DATA_TYPE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DATA_TYPE_LENTH = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.NULLABLE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DATA_DEFAULT = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.KEY_NAME = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.btnGeneratCode = new System.Windows.Forms.Button();
            this.txtSchemaName = new System.Windows.Forms.TextBox();
            this.txtPackageName = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.panel1 = new System.Windows.Forms.Panel();
            this.label3 = new System.Windows.Forms.Label();
            this.txtTableName = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.txtMsgTitle = new System.Windows.Forms.TextBox();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridView1
            // 
            this.dataGridView1.AllowUserToOrderColumns = true;
            this.dataGridView1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            dataGridViewCellStyle1.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleLeft;
            dataGridViewCellStyle1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            dataGridViewCellStyle1.Font = new System.Drawing.Font("Segoe UI", 9F, ((System.Drawing.FontStyle)((System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Underline))), System.Drawing.GraphicsUnit.Point);
            dataGridViewCellStyle1.ForeColor = System.Drawing.SystemColors.WindowText;
            dataGridViewCellStyle1.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(255)))), ((int)(((byte)(192)))));
            dataGridViewCellStyle1.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle1.WrapMode = System.Windows.Forms.DataGridViewTriState.True;
            this.dataGridView1.ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1;
            this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridView1.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.COLUMN_NAME,
            this.DATA_TYPE,
            this.DATA_TYPE_LENTH,
            this.NULLABLE,
            this.DATA_DEFAULT,
            this.KEY_NAME});
            this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dataGridView1.Location = new System.Drawing.Point(0, 143);
            this.dataGridView1.Name = "dataGridView1";
            this.dataGridView1.RowTemplate.Height = 25;
            this.dataGridView1.Size = new System.Drawing.Size(884, 533);
            this.dataGridView1.TabIndex = 0;
            // 
            // COLUMN_NAME
            // 
            dataGridViewCellStyle2.BackColor = System.Drawing.Color.White;
            this.COLUMN_NAME.DefaultCellStyle = dataGridViewCellStyle2;
            this.COLUMN_NAME.HeaderText = "COLUMN_NAME";
            this.COLUMN_NAME.Name = "COLUMN_NAME";
            this.COLUMN_NAME.Width = 200;
            // 
            // DATA_TYPE
            // 
            this.DATA_TYPE.HeaderText = "DATA_TYPE";
            this.DATA_TYPE.Name = "DATA_TYPE";
            this.DATA_TYPE.Width = 200;
            // 
            // DATA_TYPE_LENTH
            // 
            this.DATA_TYPE_LENTH.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader;
            this.DATA_TYPE_LENTH.HeaderText = "DATA_TYPE_LENTH";
            this.DATA_TYPE_LENTH.Name = "DATA_TYPE_LENTH";
            this.DATA_TYPE_LENTH.Width = 136;
            // 
            // NULLABLE
            // 
            this.NULLABLE.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader;
            this.NULLABLE.HeaderText = "NULLABLE";
            this.NULLABLE.Name = "NULLABLE";
            this.NULLABLE.Width = 90;
            // 
            // DATA_DEFAULT
            // 
            this.DATA_DEFAULT.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader;
            this.DATA_DEFAULT.HeaderText = "DATA_DEFAULT";
            this.DATA_DEFAULT.Name = "DATA_DEFAULT";
            this.DATA_DEFAULT.Width = 116;
            // 
            // KEY_NAME
            // 
            this.KEY_NAME.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.ColumnHeader;
            this.KEY_NAME.HeaderText = "KEY_NAME";
            this.KEY_NAME.Name = "KEY_NAME";
            this.KEY_NAME.Width = 92;
            // 
            // btnGeneratCode
            // 
            this.btnGeneratCode.Location = new System.Drawing.Point(766, 26);
            this.btnGeneratCode.Name = "btnGeneratCode";
            this.btnGeneratCode.Size = new System.Drawing.Size(106, 73);
            this.btnGeneratCode.TabIndex = 1;
            this.btnGeneratCode.Text = "Generat Code";
            this.btnGeneratCode.UseVisualStyleBackColor = true;
            this.btnGeneratCode.Click += new System.EventHandler(this.btnGeneratCode_Click);
            // 
            // txtSchemaName
            // 
            this.txtSchemaName.Location = new System.Drawing.Point(12, 26);
            this.txtSchemaName.Name = "txtSchemaName";
            this.txtSchemaName.Size = new System.Drawing.Size(358, 23);
            this.txtSchemaName.TabIndex = 2;
            // 
            // txtPackageName
            // 
            this.txtPackageName.Location = new System.Drawing.Point(392, 26);
            this.txtPackageName.Name = "txtPackageName";
            this.txtPackageName.Size = new System.Drawing.Size(358, 23);
            this.txtPackageName.TabIndex = 3;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 6);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(82, 15);
            this.label1.TabIndex = 4;
            this.label1.Text = "Schema name";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(392, 6);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(84, 15);
            this.label2.TabIndex = 4;
            this.label2.Text = "Package name";
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.panel1.Location = new System.Drawing.Point(4, 120);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(876, 4);
            this.panel1.TabIndex = 5;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(12, 56);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(67, 15);
            this.label3.TabIndex = 7;
            this.label3.Text = "Table name";
            // 
            // txtTableName
            // 
            this.txtTableName.Location = new System.Drawing.Point(12, 76);
            this.txtTableName.Name = "txtTableName";
            this.txtTableName.Size = new System.Drawing.Size(358, 23);
            this.txtTableName.TabIndex = 6;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(392, 56);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(58, 15);
            this.label4.TabIndex = 9;
            this.label4.Text = "Msg Title ";
            // 
            // txtMsgTitle
            // 
            this.txtMsgTitle.Location = new System.Drawing.Point(392, 76);
            this.txtMsgTitle.Name = "txtMsgTitle";
            this.txtMsgTitle.Size = new System.Drawing.Size(358, 23);
            this.txtMsgTitle.TabIndex = 8;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(884, 676);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.txtMsgTitle);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.txtTableName);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtPackageName);
            this.Controls.Add(this.txtSchemaName);
            this.Controls.Add(this.btnGeneratCode);
            this.Controls.Add(this.dataGridView1);
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DataGridView dataGridView1;
        private Button btnGeneratCode;
        private TextBox txtSchemaName;
        private TextBox txtPackageName;
        private Label label1;
        private Label label2;
        private Panel panel1;
        private DataGridViewTextBoxColumn COLUMN_NAME;
        private DataGridViewTextBoxColumn DATA_TYPE;
        private DataGridViewTextBoxColumn DATA_TYPE_LENTH;
        private DataGridViewTextBoxColumn NULLABLE;
        private DataGridViewTextBoxColumn DATA_DEFAULT;
        private DataGridViewTextBoxColumn KEY_NAME;
        private Label label3;
        private TextBox txtTableName;
        private Label label4;
        private TextBox txtMsgTitle;
    }
}
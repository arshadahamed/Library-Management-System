﻿namespace LMS.WIN.Forms.Login
{
    partial class frmLogin
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmLogin));
            this.TopPanel = new System.Windows.Forms.Panel();
            this.panel1 = new System.Windows.Forms.Panel();
            this.lblTitle = new System.Windows.Forms.Label();
            this.panelLibrary = new System.Windows.Forms.Panel();
            this.pbLibrary = new System.Windows.Forms.PictureBox();
            this.panelButton = new System.Windows.Forms.Panel();
            this.pbClose = new System.Windows.Forms.PictureBox();
            this.ButtomPanel = new System.Windows.Forms.Panel();
            this.lblCopyrights = new System.Windows.Forms.Label();
            this.ContentPanel = new System.Windows.Forms.Panel();
            this.panelLogin = new System.Windows.Forms.Panel();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.pictureBox1 = new System.Windows.Forms.PictureBox();
            this.btnClear = new System.Windows.Forms.Button();
            this.lblWarning = new System.Windows.Forms.Label();
            this.btnSignIn = new System.Windows.Forms.Button();
            this.cbRole = new System.Windows.Forms.ComboBox();
            this.checkbxShowPas = new System.Windows.Forms.CheckBox();
            this.tbPassword = new System.Windows.Forms.TextBox();
            this.tbUsername = new System.Windows.Forms.TextBox();
            this.lblRole = new System.Windows.Forms.Label();
            this.lblPassword = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.label1 = new System.Windows.Forms.Label();
            this.lblLogin = new System.Windows.Forms.Label();
            this.lblLMS = new System.Windows.Forms.Label();
            this.pbLogo = new System.Windows.Forms.PictureBox();
            this.TopPanel.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panelLibrary.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pbLibrary)).BeginInit();
            this.panelButton.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pbClose)).BeginInit();
            this.ButtomPanel.SuspendLayout();
            this.ContentPanel.SuspendLayout();
            this.panelLogin.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbLogo)).BeginInit();
            this.SuspendLayout();
            // 
            // TopPanel
            // 
            this.TopPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(56)))), ((int)(((byte)(129)))));
            this.TopPanel.Controls.Add(this.panel1);
            this.TopPanel.Controls.Add(this.panelLibrary);
            this.TopPanel.Controls.Add(this.panelButton);
            this.TopPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.TopPanel.Location = new System.Drawing.Point(0, 0);
            this.TopPanel.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.TopPanel.Name = "TopPanel";
            this.TopPanel.Size = new System.Drawing.Size(1600, 64);
            this.TopPanel.TabIndex = 0;
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.lblTitle);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panel1.Location = new System.Drawing.Point(69, 0);
            this.panel1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(1459, 64);
            this.panel1.TabIndex = 4;
            // 
            // lblTitle
            // 
            this.lblTitle.AutoSize = true;
            this.lblTitle.Font = new System.Drawing.Font("Calibri", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblTitle.ForeColor = System.Drawing.Color.White;
            this.lblTitle.Location = new System.Drawing.Point(8, 15);
            this.lblTitle.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblTitle.Name = "lblTitle";
            this.lblTitle.Size = new System.Drawing.Size(63, 33);
            this.lblTitle.TabIndex = 1;
            this.lblTitle.Text = "LMS";
            // 
            // panelLibrary
            // 
            this.panelLibrary.Controls.Add(this.pbLibrary);
            this.panelLibrary.Dock = System.Windows.Forms.DockStyle.Left;
            this.panelLibrary.Location = new System.Drawing.Point(0, 0);
            this.panelLibrary.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelLibrary.Name = "panelLibrary";
            this.panelLibrary.Size = new System.Drawing.Size(69, 64);
            this.panelLibrary.TabIndex = 3;
            // 
            // pbLibrary
            // 
            this.pbLibrary.Image = ((System.Drawing.Image)(resources.GetObject("pbLibrary.Image")));
            this.pbLibrary.Location = new System.Drawing.Point(4, 10);
            this.pbLibrary.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pbLibrary.Name = "pbLibrary";
            this.pbLibrary.Size = new System.Drawing.Size(61, 42);
            this.pbLibrary.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbLibrary.TabIndex = 0;
            this.pbLibrary.TabStop = false;
            // 
            // panelButton
            // 
            this.panelButton.Controls.Add(this.pbClose);
            this.panelButton.Dock = System.Windows.Forms.DockStyle.Right;
            this.panelButton.Location = new System.Drawing.Point(1528, 0);
            this.panelButton.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelButton.Name = "panelButton";
            this.panelButton.Size = new System.Drawing.Size(72, 64);
            this.panelButton.TabIndex = 2;
            // 
            // pbClose
            // 
            this.pbClose.Image = ((System.Drawing.Image)(resources.GetObject("pbClose.Image")));
            this.pbClose.Location = new System.Drawing.Point(5, 6);
            this.pbClose.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pbClose.Name = "pbClose";
            this.pbClose.Size = new System.Drawing.Size(59, 47);
            this.pbClose.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbClose.TabIndex = 0;
            this.pbClose.TabStop = false;
            this.pbClose.Click += new System.EventHandler(this.pbClose_Click);
            // 
            // ButtomPanel
            // 
            this.ButtomPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(56)))), ((int)(((byte)(129)))));
            this.ButtomPanel.Controls.Add(this.lblCopyrights);
            this.ButtomPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.ButtomPanel.Location = new System.Drawing.Point(0, 845);
            this.ButtomPanel.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.ButtomPanel.Name = "ButtomPanel";
            this.ButtomPanel.Size = new System.Drawing.Size(1600, 49);
            this.ButtomPanel.TabIndex = 1;
            // 
            // lblCopyrights
            // 
            this.lblCopyrights.Anchor = System.Windows.Forms.AnchorStyles.Bottom;
            this.lblCopyrights.AutoSize = true;
            this.lblCopyrights.Font = new System.Drawing.Font("Calibri", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblCopyrights.ForeColor = System.Drawing.Color.White;
            this.lblCopyrights.Location = new System.Drawing.Point(632, 16);
            this.lblCopyrights.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblCopyrights.Name = "lblCopyrights";
            this.lblCopyrights.Size = new System.Drawing.Size(313, 23);
            this.lblCopyrights.TabIndex = 2;
            this.lblCopyrights.Text = "Copyrights © 2025. All rights Reserved.";
            // 
            // ContentPanel
            // 
            this.ContentPanel.Controls.Add(this.panelLogin);
            this.ContentPanel.Controls.Add(this.lblLMS);
            this.ContentPanel.Controls.Add(this.pbLogo);
            this.ContentPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.ContentPanel.Location = new System.Drawing.Point(0, 64);
            this.ContentPanel.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.ContentPanel.Name = "ContentPanel";
            this.ContentPanel.Size = new System.Drawing.Size(1600, 781);
            this.ContentPanel.TabIndex = 2;
            // 
            // panelLogin
            // 
            this.panelLogin.Anchor = System.Windows.Forms.AnchorStyles.Top;
            this.panelLogin.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(56)))), ((int)(((byte)(129)))));
            this.panelLogin.Controls.Add(this.pictureBox2);
            this.panelLogin.Controls.Add(this.pictureBox1);
            this.panelLogin.Controls.Add(this.btnClear);
            this.panelLogin.Controls.Add(this.lblWarning);
            this.panelLogin.Controls.Add(this.btnSignIn);
            this.panelLogin.Controls.Add(this.cbRole);
            this.panelLogin.Controls.Add(this.checkbxShowPas);
            this.panelLogin.Controls.Add(this.tbPassword);
            this.panelLogin.Controls.Add(this.tbUsername);
            this.panelLogin.Controls.Add(this.lblRole);
            this.panelLogin.Controls.Add(this.lblPassword);
            this.panelLogin.Controls.Add(this.panel2);
            this.panelLogin.Controls.Add(this.label1);
            this.panelLogin.Controls.Add(this.lblLogin);
            this.panelLogin.Location = new System.Drawing.Point(519, 287);
            this.panelLogin.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panelLogin.Name = "panelLogin";
            this.panelLogin.Size = new System.Drawing.Size(603, 486);
            this.panelLogin.TabIndex = 2;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox2.Image")));
            this.pictureBox2.Location = new System.Drawing.Point(125, 193);
            this.pictureBox2.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(39, 33);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox2.TabIndex = 245;
            this.pictureBox2.TabStop = false;
            // 
            // pictureBox1
            // 
            this.pictureBox1.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox1.Image")));
            this.pictureBox1.Location = new System.Drawing.Point(125, 102);
            this.pictureBox1.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pictureBox1.Name = "pictureBox1";
            this.pictureBox1.Size = new System.Drawing.Size(39, 33);
            this.pictureBox1.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pictureBox1.TabIndex = 244;
            this.pictureBox1.TabStop = false;
            // 
            // btnClear
            // 
            this.btnClear.BackColor = System.Drawing.Color.White;
            this.btnClear.FlatAppearance.BorderSize = 0;
            this.btnClear.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnClear.Font = new System.Drawing.Font("Calibri", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnClear.ForeColor = System.Drawing.Color.Red;
            this.btnClear.Location = new System.Drawing.Point(125, 407);
            this.btnClear.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(119, 52);
            this.btnClear.TabIndex = 6;
            this.btnClear.Text = "Clear";
            this.btnClear.UseVisualStyleBackColor = false;
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // lblWarning
            // 
            this.lblWarning.AutoSize = true;
            this.lblWarning.Cursor = System.Windows.Forms.Cursors.Hand;
            this.lblWarning.Font = new System.Drawing.Font("Nirmala UI", 12F, System.Drawing.FontStyle.Bold);
            this.lblWarning.ForeColor = System.Drawing.Color.White;
            this.lblWarning.Location = new System.Drawing.Point(131, 278);
            this.lblWarning.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblWarning.Name = "lblWarning";
            this.lblWarning.Size = new System.Drawing.Size(0, 28);
            this.lblWarning.TabIndex = 243;
            // 
            // btnSignIn
            // 
            this.btnSignIn.BackColor = System.Drawing.Color.White;
            this.btnSignIn.FlatAppearance.BorderSize = 0;
            this.btnSignIn.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnSignIn.Font = new System.Drawing.Font("Calibri", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnSignIn.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(56)))), ((int)(((byte)(129)))));
            this.btnSignIn.Location = new System.Drawing.Point(252, 407);
            this.btnSignIn.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.btnSignIn.Name = "btnSignIn";
            this.btnSignIn.Size = new System.Drawing.Size(243, 52);
            this.btnSignIn.TabIndex = 5;
            this.btnSignIn.Text = "SignIn";
            this.btnSignIn.UseVisualStyleBackColor = false;
            this.btnSignIn.Click += new System.EventHandler(this.btnSignIn_Click);
            // 
            // cbRole
            // 
            this.cbRole.Font = new System.Drawing.Font("Calibri", 14.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.cbRole.FormattingEnabled = true;
            this.cbRole.Items.AddRange(new object[] {
            "ADMIN",
            "LIBRARIAN"});
            this.cbRole.Location = new System.Drawing.Point(125, 350);
            this.cbRole.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.cbRole.Name = "cbRole";
            this.cbRole.Size = new System.Drawing.Size(368, 37);
            this.cbRole.TabIndex = 4;
            // 
            // checkbxShowPas
            // 
            this.checkbxShowPas.AutoSize = true;
            this.checkbxShowPas.Cursor = System.Windows.Forms.Cursors.Hand;
            this.checkbxShowPas.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.checkbxShowPas.Font = new System.Drawing.Font("Calibri", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.checkbxShowPas.ForeColor = System.Drawing.Color.White;
            this.checkbxShowPas.Location = new System.Drawing.Point(345, 278);
            this.checkbxShowPas.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.checkbxShowPas.Name = "checkbxShowPas";
            this.checkbxShowPas.Size = new System.Drawing.Size(137, 25);
            this.checkbxShowPas.TabIndex = 3;
            this.checkbxShowPas.Text = "Show Password";
            this.checkbxShowPas.UseVisualStyleBackColor = true;
            this.checkbxShowPas.CheckedChanged += new System.EventHandler(this.checkbxShowPas_CheckedChanged);
            // 
            // tbPassword
            // 
            this.tbPassword.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.tbPassword.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tbPassword.Font = new System.Drawing.Font("Calibri", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbPassword.Location = new System.Drawing.Point(125, 233);
            this.tbPassword.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbPassword.Multiline = true;
            this.tbPassword.Name = "tbPassword";
            this.tbPassword.PasswordChar = '*';
            this.tbPassword.Size = new System.Drawing.Size(369, 38);
            this.tbPassword.TabIndex = 2;
            this.tbPassword.KeyDown += new System.Windows.Forms.KeyEventHandler(this.tbPassword_KeyDown);
            // 
            // tbUsername
            // 
            this.tbUsername.Anchor = System.Windows.Forms.AnchorStyles.Left;
            this.tbUsername.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.tbUsername.Font = new System.Drawing.Font("Calibri", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tbUsername.Location = new System.Drawing.Point(125, 142);
            this.tbUsername.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.tbUsername.Multiline = true;
            this.tbUsername.Name = "tbUsername";
            this.tbUsername.Size = new System.Drawing.Size(369, 38);
            this.tbUsername.TabIndex = 1;
            // 
            // lblRole
            // 
            this.lblRole.AutoSize = true;
            this.lblRole.Font = new System.Drawing.Font("Calibri", 16F, System.Drawing.FontStyle.Bold);
            this.lblRole.ForeColor = System.Drawing.Color.White;
            this.lblRole.Location = new System.Drawing.Point(123, 313);
            this.lblRole.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblRole.Name = "lblRole";
            this.lblRole.Size = new System.Drawing.Size(66, 33);
            this.lblRole.TabIndex = 4;
            this.lblRole.Text = "Role";
            // 
            // lblPassword
            // 
            this.lblPassword.AutoSize = true;
            this.lblPassword.Font = new System.Drawing.Font("Calibri", 16F, System.Drawing.FontStyle.Bold);
            this.lblPassword.ForeColor = System.Drawing.Color.White;
            this.lblPassword.Location = new System.Drawing.Point(168, 193);
            this.lblPassword.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblPassword.Name = "lblPassword";
            this.lblPassword.Size = new System.Drawing.Size(122, 33);
            this.lblPassword.TabIndex = 3;
            this.lblPassword.Text = "Password";
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.Color.White;
            this.panel2.Location = new System.Drawing.Point(55, 68);
            this.panel2.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(511, 7);
            this.panel2.TabIndex = 2;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Calibri", 16F, System.Drawing.FontStyle.Bold);
            this.label1.ForeColor = System.Drawing.Color.White;
            this.label1.Location = new System.Drawing.Point(168, 102);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(131, 33);
            this.label1.TabIndex = 1;
            this.label1.Text = "Username";
            // 
            // lblLogin
            // 
            this.lblLogin.AutoSize = true;
            this.lblLogin.Font = new System.Drawing.Font("Calibri", 24F, System.Drawing.FontStyle.Bold);
            this.lblLogin.ForeColor = System.Drawing.Color.White;
            this.lblLogin.Location = new System.Drawing.Point(243, 11);
            this.lblLogin.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblLogin.Name = "lblLogin";
            this.lblLogin.Size = new System.Drawing.Size(111, 49);
            this.lblLogin.TabIndex = 0;
            this.lblLogin.Text = "Login";
            // 
            // lblLMS
            // 
            this.lblLMS.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)));
            this.lblLMS.AutoSize = true;
            this.lblLMS.Font = new System.Drawing.Font("Calibri", 27.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblLMS.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(2)))), ((int)(((byte)(56)))), ((int)(((byte)(129)))));
            this.lblLMS.Location = new System.Drawing.Point(515, 226);
            this.lblLMS.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.lblLMS.Name = "lblLMS";
            this.lblLMS.Size = new System.Drawing.Size(580, 58);
            this.lblLMS.TabIndex = 1;
            this.lblLMS.Text = "Library Management System";
            // 
            // pbLogo
            // 
            this.pbLogo.Anchor = System.Windows.Forms.AnchorStyles.Top;
            this.pbLogo.Image = ((System.Drawing.Image)(resources.GetObject("pbLogo.Image")));
            this.pbLogo.Location = new System.Drawing.Point(716, 43);
            this.pbLogo.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.pbLogo.Name = "pbLogo";
            this.pbLogo.Size = new System.Drawing.Size(212, 180);
            this.pbLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbLogo.TabIndex = 0;
            this.pbLogo.TabStop = false;
            // 
            // frmLogin
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.AutoValidate = System.Windows.Forms.AutoValidate.EnableAllowFocusChange;
            this.BackColor = System.Drawing.Color.White;
            this.ClientSize = new System.Drawing.Size(1600, 894);
            this.Controls.Add(this.ContentPanel);
            this.Controls.Add(this.ButtomPanel);
            this.Controls.Add(this.TopPanel);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Margin = new System.Windows.Forms.Padding(4, 4, 4, 4);
            this.Name = "frmLogin";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmLogin";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmLogin_Load);
            this.TopPanel.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panelLibrary.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pbLibrary)).EndInit();
            this.panelButton.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pbClose)).EndInit();
            this.ButtomPanel.ResumeLayout(false);
            this.ButtomPanel.PerformLayout();
            this.ContentPanel.ResumeLayout(false);
            this.ContentPanel.PerformLayout();
            this.panelLogin.ResumeLayout(false);
            this.panelLogin.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbLogo)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel TopPanel;
        private System.Windows.Forms.Panel ButtomPanel;
        private System.Windows.Forms.Panel ContentPanel;
        private System.Windows.Forms.Label lblTitle;
        private System.Windows.Forms.PictureBox pbLibrary;
        private System.Windows.Forms.Label lblCopyrights;
        private System.Windows.Forms.Panel panelButton;
        private System.Windows.Forms.PictureBox pbClose;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panelLibrary;
        private System.Windows.Forms.PictureBox pbLogo;
        private System.Windows.Forms.Label lblLMS;
        private System.Windows.Forms.Panel panelLogin;
        private System.Windows.Forms.Label lblLogin;
        private System.Windows.Forms.TextBox tbUsername;
        private System.Windows.Forms.Label lblRole;
        private System.Windows.Forms.Label lblPassword;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cbRole;
        private System.Windows.Forms.TextBox tbPassword;
        private System.Windows.Forms.Label lblWarning;
        private System.Windows.Forms.CheckBox checkbxShowPas;
        private System.Windows.Forms.Button btnClear;
        private System.Windows.Forms.Button btnSignIn;
        private System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.PictureBox pictureBox1;
    }
}
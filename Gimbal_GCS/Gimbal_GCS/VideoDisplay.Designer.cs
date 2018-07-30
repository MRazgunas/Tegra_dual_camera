namespace Gimbal_GCS
{
    partial class VideoDisplay
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
            this.videoPanel = new System.Windows.Forms.Panel();
            this.noVidSig = new System.Windows.Forms.Label();
            this.videoPanel.SuspendLayout();
            this.SuspendLayout();
            // 
            // videoPanel
            // 
            this.videoPanel.BackColor = System.Drawing.Color.Black;
            this.videoPanel.Controls.Add(this.noVidSig);
            this.videoPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.videoPanel.Location = new System.Drawing.Point(0, 0);
            this.videoPanel.Name = "videoPanel";
            this.videoPanel.Size = new System.Drawing.Size(948, 450);
            this.videoPanel.TabIndex = 0;
            // 
            // noVidSig
            // 
            this.noVidSig.AutoSize = true;
            this.noVidSig.BackColor = System.Drawing.Color.Black;
            this.noVidSig.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.noVidSig.ForeColor = System.Drawing.Color.Red;
            this.noVidSig.Location = new System.Drawing.Point(12, 9);
            this.noVidSig.Name = "noVidSig";
            this.noVidSig.Size = new System.Drawing.Size(236, 37);
            this.noVidSig.TabIndex = 1;
            this.noVidSig.Text = "No video signal";
            this.noVidSig.Visible = false;
            // 
            // VideoDisplay
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(948, 450);
            this.Controls.Add(this.videoPanel);
            this.Name = "VideoDisplay";
            this.Text = "VideoDisplay";
            this.videoPanel.ResumeLayout(false);
            this.videoPanel.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel videoPanel;
        private System.Windows.Forms.Label noVidSig;
    }
}
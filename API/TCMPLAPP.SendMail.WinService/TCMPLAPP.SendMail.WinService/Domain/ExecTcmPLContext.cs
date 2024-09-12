using Microsoft.EntityFrameworkCore;

namespace TCMPLAPP.SendMail.WinService.Context
{
    public partial class ExecTcmPLContext : DbContext
    {
        public bool DisableCache { get; set; }

        public ExecTcmPLContext()
        {
        }

        public ExecTcmPLContext(DbContextOptions<ExecTcmPLContext> options)
            : base(options)
        {
            this.DisableCache = false;
        }

        public ExecTcmPLContext(DbContextOptions<ExecTcmPLContext> options, ExecTcmPLContextOption execTcmPLContextOption)
            : base(options)
        {
            if (execTcmPLContextOption != null)
                this.DisableCache = execTcmPLContextOption.DisableCache;
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.1.1");
        }
    }
}

using Microsoft.EntityFrameworkCore;

namespace TCMPLApp.Domain.Context
{
    public partial class ViewTcmPLContext : DbContext
    {

        public bool DisableCache { get; set; }

        public ViewTcmPLContext()
        {
        }

        public ViewTcmPLContext(DbContextOptions<ViewTcmPLContext> options)
            : base(options)
        {
            this.DisableCache = false;
        }

        public ViewTcmPLContext(DbContextOptions<ViewTcmPLContext> options, ViewTcmPLContextOption viewTcmPLContextOption)
            : base(options)
        {
            if (viewTcmPLContextOption != null)
                this.DisableCache = viewTcmPLContextOption.DisableCache;
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("ProductVersion", "2.1.1");
        }
    }
}

using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpEmpTrainingConfiguration : IEntityTypeConfiguration<SwpEmpTraining>
    {

        public void Configure(EntityTypeBuilder<SwpEmpTraining> entity)
        {
            entity.HasKey(e => e.Empno)
                .HasName("SWP_EMP_TRAINING_PK");

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Onedrive365).HasPrecision(1);

            entity.Property(e => e.Planner).HasPrecision(1);

            entity.Property(e => e.Security).HasPrecision(1);

            entity.Property(e => e.Sharepoint16).HasPrecision(1);

            entity.Property(e => e.Teams).HasPrecision(1);

        }
    }
}

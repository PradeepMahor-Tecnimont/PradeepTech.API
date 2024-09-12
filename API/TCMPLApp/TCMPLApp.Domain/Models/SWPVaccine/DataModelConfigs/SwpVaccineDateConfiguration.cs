using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVaccineDateConfiguration : IEntityTypeConfiguration<SwpVaccineDate>
    {
        public void Configure(EntityTypeBuilder<SwpVaccineDate> entity)
        {
            entity.HasKey(e => e.Empno)
                .HasName("SWP_VACCINE_DATES_PK");

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.VaccineType).IsUnicode(false);

            entity.HasOne(d => d.VaccineTypeNavigation)
                .WithMany(p => p.SwpVaccineDates)
                .HasForeignKey(d => d.VaccineType)
                .HasConstraintName("SWP_VACCINE_DATES_FK1");

        }
    }
}
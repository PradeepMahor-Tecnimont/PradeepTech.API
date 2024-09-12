using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpTplVaccineBatchEmpConfiguration  : IEntityTypeConfiguration<SwpTplVaccineBatchEmp>
    {
        public void Configure(EntityTypeBuilder<SwpTplVaccineBatchEmp> entity)
        {
            entity.HasKey(e => e.Empno)
                .HasName("SWP_TPL_VACCINE_BATCH_EMP_PK");

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.BatchKeyId).IsUnicode(false);

            entity.Property(e => e.JabForThisSlot).IsUnicode(false);

            entity.Property(e => e.TimeSlot).IsUnicode(false);

            entity.Property(e => e.Transport).IsUnicode(false);

            entity.Property(e => e.Inoculated).IsUnicode(false);

            entity.HasOne(d => d.BatchKey)
                .WithMany(p => p.SwpTplVaccineBatchEmps)
                .HasForeignKey(d => d.BatchKeyId)
                .HasConstraintName("SWP_TPL_VACCINE_BATCH_EMP_FK1");
        }
    }
}
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVuTplVaccineBatchDetConfiguration : IEntityTypeConfiguration<SwpVuTplVaccineBatchDet>
    {
        public void Configure(EntityTypeBuilder<SwpVuTplVaccineBatchDet> entity)
        {
            entity.ToView("SWP_VU_TPL_VACCINE_BATCH_DET");

            entity.Property(e => e.BatchKeyId).IsUnicode(false);

            entity.Property(e => e.DepartmentName).IsUnicode(false);

            entity.Property(e => e.Email).IsUnicode(false);

            entity.Property(e => e.Empno)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Emptype)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.Grade).IsUnicode(false);

            entity.Property(e => e.JabForThisSlot).IsUnicode(false);

            entity.Property(e => e.EmployeeName).IsUnicode(false);

            entity.Property(e => e.Parent)
                .IsUnicode(false)
                .IsFixedLength(true);

            entity.Property(e => e.TimeSlot).IsUnicode(false);

            entity.Property(e => e.Transport).IsUnicode(false);

            entity.Property(e => e.Inoculated).IsUnicode(false);
        }
    }
}
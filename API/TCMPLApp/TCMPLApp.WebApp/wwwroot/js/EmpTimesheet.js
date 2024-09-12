function loadDataBasedOnDepartment(costcode, monthyear, url, empno) {
    $.ajax({
        url: url,
        type: 'GET',
        data:
        {
            costcode: costcode,
            yymm: $('#Yyyymm').val(),
            empno: empno
        },
        beforeSend: function () {
            showModalLoader();
        },
        success: function (data) {
            var normalHours = null;
            var oTHours = null;
            var holidays = null;
            $(data).each(function () {

                if (this.pExceed == 1) {
                    $('#Exceed').text("(Exceeding 240 hours)");
                }

                $('#Remarks').text(this.pRemark);
                $('#TimesheetStatus').text(this.pStatus);
                $('#timesheetTable').css("text-align","center");

                normalHours = this.pTimeDaily;
                oTHours = this.pTimeOt;
                holidays = this.pHolidays;
            });
            if (data.pMessageType == "OK") {
                createTimeSheetTable(normalHours, oTHours, holidays, monthyear);
            }
            else {
                $('#TimesheetStatus').text("Timesheet data is not available for this month");
                $('#TimesheetStatus').css("color", "red", "font-weight", "bold");
                $('#timesheetdetails').addClass("hidden");
            }
        },
        error: function (result) {
            showError(result);
        },
        complete: function (xhr, status) {
            hideModalLoader();
        }
    });
}

function createTimeSheetTable(dailyhours, overtimehours, holidays, monthyear) {
    const tableContainer = document.getElementById('timesheetTable');

    const selectedmonth = $('#Yyyymm').val().slice(-2);
    const selectedyear = $('#Yyyymm').val().slice(0, 4);

    const daysInMonth = new Date(new Date().getFullYear(), selectedmonth, 0).getDate();

    const firstDayOfMonth = new Date(selectedyear, selectedmonth - 1, 1);
    const startingDayOfWeek = firstDayOfMonth.getDay();

    $('#timesheetTable').empty();
    $('#timesheetdetails').removeClass("hidden");

    $('#monthYear').text(monthyear);

    const table = document.createElement('table');

    const headerData = ['Job Number', 'WP', 'Activity Code'];
    const dayNames = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    for (let i = 1; i <= daysInMonth; i++) {
        headerData.push(dayNames[(startingDayOfWeek + i - 1) % 7] + ' ' + i);
    }
    headerData.push('Month Total', 'Note');

    const jsonNormalData = dailyhours || [];

    const jsonOvertimeData = overtimehours || [];

    const jsonHolidaysData = holidays;

    createRow(table, 'th', headerData, daysInMonth, jsonHolidaysData);
    tableContainer.appendChild(table);

    createNormalHoursRow(table, daysInMonth);

    for (let i = 0; i < jsonNormalData.length; i++) {
        createNormalHoursEditableRow(table, daysInMonth, jsonNormalData[i], jsonHolidaysData);
    }

    createSubtotalRow(table, daysInMonth, jsonHolidaysData);
    createOvertimeRow(table, daysInMonth);

    for (let i = 0; i < jsonOvertimeData.length; i++) {
        createOvertimeEditableRow(table, daysInMonth, jsonOvertimeData[i], jsonHolidaysData);
    }

    createOvertimeSubtotalRow(table, daysInMonth, jsonHolidaysData);
    createTotalMonthlyHoursRow(table, daysInMonth, jsonHolidaysData);
}

// use for create row...
function createRow(table, cellType, data, daysInMonth, jsonHolidaysData) {
    const row = document.createElement('tr');
    data.forEach((item, index) => {
        const cell = document.createElement(cellType);
        cell.textContent = item;

        const dayIndex = index - 3;

        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((dayIndex + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }
        row.appendChild(cell);
    });


    table.appendChild(row);
}

// use for create normalhours row
function createNormalHoursRow(table, daysInMonth) {
    const row = document.createElement('tr');
    const NormalHoursCell = document.createElement('td');
    NormalHoursCell.colSpan = daysInMonth + 5;
    NormalHoursCell.textContent = 'Normal Hours';
    NormalHoursCell.style.fontWeight = 'bold';
    NormalHoursCell.style.textAlign = 'left';
    row.appendChild(NormalHoursCell);
    table.appendChild(row);
}

// use to create editable row...
function createNormalHoursEditableRow(table, daysInMonth, data, jsonHolidaysData) {
    const row = document.createElement('tr');
    const cellIDs = ['projno', 'wpcode', 'activity'];
    for (const id of cellIDs) {
        const cell = createEditableCell(id);
        cell.querySelector('label').textContent = data[id];
        row.appendChild(cell);
    }

    for (let i = 0; i < daysInMonth; i++) {
        const cell = createEditableCell('d' + (i + 1));
        cell.classList.add('dayCell_' + i);
        cell.querySelector('label').textContent = data && data['d' + (i + 1)] ? data['d' + (i + 1)] : '';

        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((i + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }

        row.appendChild(cell);
    }

    row.appendChild(createEditableCell('monthTotal')).querySelector('label').textContent = data.total;
    row.lastChild.querySelector('label').style.fontWeight = 'bold';
    row.appendChild(createEditableCell('note')).querySelector('label').textContent = data.note;
    table.appendChild(row);
}

function createOvertimeEditableRow(table, daysInMonth, data, jsonHolidaysData) {
    const row = document.createElement('tr');
    const cellIDs = ['projno', 'wpcode', 'activity'];
    for (const id of cellIDs) {
        const cell = createEditableCell(id);
        cell.querySelector('label').textContent = data[id]; // Check if data exists
        row.appendChild(cell);
    }

    for (let i = 0; i < daysInMonth; i++) {
        const cell = createEditableCell('d' + (i + 1));
        cell.classList.add('OTCell_' + i);
        cell.querySelector('label').textContent = data && data['d' + (i + 1)] ? data['d' + (i + 1)] : ''; // Check if data exists

        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((i + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }

        row.appendChild(cell);
    }

    row.appendChild(createEditableCell('monthTotal')).querySelector('label').textContent = data.total;
    row.lastChild.querySelector('label').style.fontWeight = 'bold';
    row.appendChild(createEditableCell('note')).querySelector('label').textContent = data.note;
    table.appendChild(row);
}

// use to male sell editable...
function createEditableCell(id) {
    const cell = document.createElement('td');
    const label = document.createElement('label');
    // label.setAttribute('contenteditable', 'true');
    label.id = id;
    cell.appendChild(label);
    return cell;
}

// use to create sub total row
function createSubtotalRow(table, daysInMonth, jsonHolidaysData) {
    const row = document.createElement('tr');
    const subtotalCell = document.createElement('td');
    subtotalCell.colSpan = 3;
    subtotalCell.textContent = 'Sub-total of Normal Hours';
    subtotalCell.style.textAlign = 'left';
    row.appendChild(subtotalCell);
    let normalhoursTotal = 0;

    for (let i = 0; i < daysInMonth; i++) {
        const cell = createEditableCell('normalSubtotal_' + (i + 1));
        const dayCells = table.querySelectorAll('.dayCell_' + i);
        let subtotal = 0;

        dayCells.forEach((dayCell) => {
            subtotal += parseFloat(dayCell.textContent) || 0;
        });

        if (subtotal != 0) {
            cell.querySelector('label').textContent = subtotal;
        }

        normalhoursTotal += subtotal;
        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((i + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }
        row.appendChild(cell);
    }

    row.appendChild(createEditableCell('normalhoursTotal')).querySelector('label').textContent = normalhoursTotal;
    row.lastChild.querySelector('label').style.fontWeight = 'bold';
    row.appendChild(createEditableCell('note'));
    table.appendChild(row);
}

// use to create Overtime row
function createOvertimeRow(table, daysInMonth) {
    const row = document.createElement('tr');
    const overtimeCell = document.createElement('td');
    overtimeCell.colSpan = daysInMonth + 5;
    overtimeCell.textContent = 'Overtime';
    overtimeCell.style.fontWeight = 'bold';
    overtimeCell.style.textAlign = 'left';
    row.appendChild(overtimeCell);
    table.appendChild(row);
}

// use to create Overtime subtotal row
function createOvertimeSubtotalRow(table, daysInMonth, jsonHolidaysData) {
    const row = document.createElement('tr');
    const subtotalCell = document.createElement('td');
    subtotalCell.colSpan = 3;
    subtotalCell.textContent = 'Sub-total of Overtime';
    subtotalCell.style.textAlign = 'left';
    row.appendChild(subtotalCell);

    let OverTimehoursTotal = 0;

    for (let i = 0; i < daysInMonth; i++) {
        const cell = createEditableCell('overtimeSubtotal_' + (i + 1));
        const dayCells = table.querySelectorAll('.OTCell_' + i);
        let subtotal = 0;

        dayCells.forEach((dayCell) => {
            subtotal += parseFloat(dayCell.textContent) || 0;
        });
        if (subtotal != 0) {
            cell.querySelector('label').textContent = subtotal;
        }

        OverTimehoursTotal += subtotal;

        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((i + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }

        row.appendChild(cell);
    }
    row.appendChild(createEditableCell('overtimehoursTotal')).querySelector('label').textContent = OverTimehoursTotal;
    row.lastChild.querySelector('label').style.fontWeight = 'bold';
    row.appendChild(createEditableCell('note'));
    table.appendChild(row);
}

// use to create total monthly hours row
function createTotalMonthlyHoursRow(table, daysInMonth, jsonHolidaysData) {
    const row = document.createElement('tr');
    const totalHoursCell = document.createElement('td');
    totalHoursCell.colSpan = 3;
    totalHoursCell.textContent = 'Total Monthly Hours';
    totalHoursCell.style.textAlign = 'left';
    row.appendChild(totalHoursCell);

    let totalMonthlyHours = 0;

    for (let i = 0; i < daysInMonth; i++) {

        const normalSubtotalCell = document.getElementById('normalSubtotal_' + (i + 1));
        const overtimeSubtotalCell = document.getElementById('overtimeSubtotal_' + (i + 1));

        const normalHours = parseFloat(normalSubtotalCell.textContent) || 0;
        const overtimeHours = parseFloat(overtimeSubtotalCell.textContent) || 0;

        const totalHours = normalHours + overtimeHours;
        totalMonthlyHours += totalHours;

        const cell = createEditableCell('totalMonthlyHours_' + (i + 1));

        if (totalHours != 0) {
            cell.querySelector('label').textContent = totalHours;
        }


        if (jsonHolidaysData.length > 0 && jsonHolidaysData[0].days.includes((i + 1).toString().padStart(2, '0'))) {
            cell.classList.add('weekend');
        }
        row.appendChild(cell);

    }

    row.appendChild(createEditableCell('totalmonthHours')).querySelector('label').textContent = totalMonthlyHours;
    row.lastChild.querySelector('label').style.fontWeight = 'bold';
    row.appendChild(createEditableCell('note'));
    table.appendChild(row);
}

import xlrd
import csv
import glob
import os
from subprocess import call
path = "/Users/pgoldsmithpinkham/Dropbox/Papers/Bankruptcy/bkcredit/SOI_ZipIncome/AllFiles/"
path = "c:/Users/Paul/Dropbox/Papers/Bankruptcy/bkcredit/SOI_ZipIncome/AllFiles/"
### Rename Files
os.chdir(path)
for fname in glob.glob("./*.xls"):
    if "tab" in fname:
        newfn = "ZIP Code " + "20"+fname[-8:-6] + " " + fname[-6:-4].upper() + ".xls"
        print newfn
        call(["mv", fname, newfn])
    elif "zp" in fname:
        if "98" in fname: 
            newfn = "ZIP Code " + "19"+fname[2:4] + " " + fname[-6:-4].upper() + ".xls"
            print newfn
            call(["mv", fname, newfn])
        else:
            newfn = "ZIP Code " + "20"+fname[2:4] + " " + fname[-6:-4].upper() + ".xls"
            print newfn
            call(["mv", fname, newfn])


for fname in glob.glob("./*1998*.xls"):
    print fname
    wd = xlrd.open_workbook(fname)
    sh = wd.sheet_by_index(0)
    outfname = fname[2:-4]
    with open('RawOutput/' + outfname + '.csv', 'wb') as f:
        writer = csv.writer(f)
        for i in range(sh.nrows):
            try:
                if sh.row_values(i)[0] != "* indicates that the value in the cell has been suppressed to avoid disclosure":
                    writer.writerow(sh.row_values(i))
            except UnicodeEncodeError:
                print sh.row_values(i)
    with open('RawOutput/' + outfname + '.csv', 'rb') as f:
        with open('CSV/' + outfname +'.csv', 'wb') as g:
            reader = csv.reader(f)
            writer = csv.writer(g)
            year = int(outfname[9:13])
            if year == 1998:
                # Remove Header
                headerNum = 8
                for line in range(headerNum):
                    reader.next()
                header = ["Income Bucket", "Location", "Number of Returns", "Total Number of Exemptions", "Number of Dependent Exemptions", "Adjusted Gross Income", "Salaries and Wages - Number of Returns", "Salaries and Wages - Amount", "Taxable Interest - Number of Returns", "Taxable Interest - Amount", "Earned Income Credit - Number of Returns", "Earned Income Credit - Amount", "Total Tax - Number of Returns", "Total Tax - Amount", "Schedule C - Number of Returns", "Number of Schedules C",  "Schedule F - Number of Returns", "Number of Schedules F", "Schedule A Deductions - Number of Returns", "Schedule A Deducations - Amount"]
                writer.writerow(header)
                for line in reader:
                    if line[0].strip() == "" and line[1].strip() == "":
                        pass
                    elif line[0].strip() not in  ["Under $10,000", "$10,000 under $25,000", "$25,000 under $50,000", "$50,000 or more"]:
                        area = line[0]
                        writer.writerow(["All"]+ line)
                    else:
                        writer.writerow([line[0]] + [area] +  line[1:])
            elif year == 2001:
                # Remove Header
                headerNum = 8
                for line in range(headerNum):
                    reader.next()
                header = ["Income Bucket", "Location", "Number of Returns", "Total Number of Exemptions", "Number of Dependent Exemptions", "Adjusted Gross Income", "Salaries and Wages - Number of Returns", "Salaries and Wages - Amount", "Taxable Interest - Number of Returns", "Taxable Interest - Amount", "Total Tax - Number of Returns", "Total Tax - Amount", "Schedule C - Number of Returns", "Schedule F - Number of Returns", "Schedule A - Number of Returns"]
                writer.writerow(header)
                for line in reader:
                    if line[0].strip() == "" and line[1].strip() == "":
                        pass
                    elif line[0].strip() not in  ["Under $10,000", "$10,000 under $25,000", "$25,000 under $50,000", "$50,000 or more"]:
                        area = line[0]
                        writer.writerow(["All"]+ line)
                    else:
                        writer.writerow([line[0]] + [area] +  line[1:])
            elif year == 2002:
                # Remove Header
                headerNum = 8
                for line in range(headerNum):
                    reader.next()
                header = ["Income Bucket", "Location", "Number of Returns", "Total Number of Exemptions", "Number of Dependent Exemptions", "Adjusted Gross Income", "Salaries and Wages - Number of Returns", "Salaries and Wages - Amount", "Taxable Interest - Number of Returns", "Taxable Interest - Amount", "Total Tax - Number of Returns", "Total Tax - Amount", "Contributions - Number of Returns", "Contributions - Amount", "Schedule C - Number of Returns", "Schedule F - Number of Returns", "Schedule A - Number of Returns"]
                writer.writerow(header)
                for line in reader:
                    if line[0].strip() == "" and line[1].strip() == "":
                        pass
                    elif line[0].strip().replace("$","") not in  ["Under 10,000", "10,000 under 25,000", "25,000 under 50,000", "50,000 or more"]:
                        area = line[0]
                        writer.writerow(["All"]+ line)
                    else:
                        writer.writerow([line[0]] + [area] + line[1:])
            elif year == 2004 or year == 2005:
                # Remove Header
                headerNum = 10
                for line in range(headerNum):
                    reader.next()
                header = ["Income Bucket", "Location", "Number of Returns", "Total Number of Exemptions", "Number of Dependent Exemptions", "Adjusted Gross Income", "Salaries and Wages - Number of Returns", "Salaries and Wages - Amount", "Taxable Interest - Number of Returns", "Taxable Interest - Amount", "Taxable Dividends - Number of Returns", "Taxable Dividends - Amount", "Net Capital Gain/Loss - Number of Returns", "Net Capital Gain/Loss - Amount", "Schedule C Net Profit/Loss - Number of Returns", "Schedule C Net Profit/Loss - Amount", "Schedule F Net Profit/Loss - Number of Returns", "Schedule F Net Profit/Loss - Amount", "IRA Payment Deduction - Number of Returns", "IRA Payment Deduction - Amount", "Self-employed Pension Deduction - Number of Returns", "Self-employed Pension Deduction - Amount", "Total Itemized Deductions - Number of Returns", "Total Itemized Deductions - Adjusted Gross Income", "Total Itemized Deductions - Amount", "Contributions Deductions - Number of Returns", "Contributions Deductions - Adjusted Gross Income", "Contributions Deductions - Amount", "Taxes Paid Deductions - Number of Returns", "Taxes Paid Deductions - Adjusted Gross Income", "Taxes Paid Deductions - Amount", "Alternative Minimum Tax - Number of Returns", "Alternative Minimum Tax - Amount", "Income Tax Before Credits - Number of Returns", "Income Tax Before Credits - Amount", "Total Tax - Number of Returns", "Total Tax - Amount", "Earned Income Credit - Number of Returns", "Earned Income Credit - Amount", "Paid Preparer - Number of Returns"]
                writer.writerow(header)
                for line in reader:
                    if line[0].strip() == "" and line[1].strip() == "":
                        pass
                    elif line[0].strip().replace("$","") not in ["Under 10,000", "10,000 under 25,000", "25,000 under 50,000", "50,000 under 75,000", "75,000 under 100,000", "100,000 or more", "100,000 under 200,000", "200,000 or more"]:
                        area = line[0]
                        writer.writerow([area] + line)
                    else:
                        writer.writerow([line[0]] + [area] + line[1:])
            elif year == 2006:
                # Remove Header
                headerNum = 10
                for line in range(headerNum):
                    reader.next()
                header = ["Income Bucket", "Location", "Number of Returns", "Total Number of Exemptions", "Number of Dependent Exemptions", "Adjusted Gross Income", "Salaries and Wages - Number of Returns", "Salaries and Wages - Amount", "Taxable Interest - Number of Returns", "Taxable Interest - Amount", "Taxable Dividends - Number of Returns", "Taxable Dividends - Amount", "Net Capital Gain/Loss - Number of Returns", "Net Capital Gain/Loss - Amount", "Schedule C Net Profit/Loss - Number of Returns", "Schedule C Net Profit/Loss - Amount", "Schedule F Net Profit/Loss - Number of Returns", "Schedule F Net Profit/Loss - Amount", "IRA Payment Deduction - Number of Returns", "IRA Payment Deduction - Amount", "Self-employed Pension Deduction - Number of Returns", "Self-employed Pension Deduction - Amount", "Total Itemized Deductions - Number of Returns", "Total Itemized Deductions - Adjusted Gross Income", "Total Itemized Deductions - Amount", "Contributions Deductions - Number of Returns", "Contributions Deductions - Adjusted Gross Income", "Contributions Deductions - Amount", "Taxes Paid Deductions - Number of Returns", "Taxes Paid Deductions - Adjusted Gross Income", "Taxes Paid Deductions - Amount", "Alternative Minimum Tax - Number of Returns", "Alternative Minimum Tax - Amount", "Income Tax Before Credits - Number of Returns", "Income Tax Before Credits - Amount", "Total Tax - Number of Returns", "Total Tax - Amount", "Earned Income Credit - Number of Returns", "Earned Income Credit - Amount", "Paid Preparer - Number of Returns"]
                writer.writerow(header)
                for line in reader:
                    if line[0].strip() == "" and line[1].strip() == "":
                        pass
                    elif line[0].strip().replace("$","") not in ["Under 10,000", "10,000 under 25,000", "25,000 under 50,000", "50,000 under 75,000", "75,000 under 100,000", "100,000 or more", "100,000 under 200,000", "200,000 or more"]:
                        area = line[0]
                        writer.writerow([area] + line[1:])
                    else:
                        writer.writerow([line[0]] + [area] + line[2:])
            elif year == 2007:
                # Remove Header
                headerNum = 4
                for line in range(headerNum):
                    reader.next()
                # Fix Variables
                var = reader.next()
                header = var[:8]
                for i in range(4):
                    header = header + ["-".join(x) for x in zip([var[8+2*i],var[8+2*i]], ["Number of Returns", "Amount of Returns"])]
                header = header +  [var[16] + " Number of Returns"]
                for i in range(len(var[17:])/2):
                    header = header +  ["-".join(x) for x in zip([var[17+2*i],var[17+2*i]], ["Number of Returns", "Amount of Returns"])]
                writer.writerow(header)
                headerNum = 3
                for line in range(headerNum):
                    reader.next()
                for line in reader:
                    if line[0] == "" and line[1] != "":
                        writer.writerow(["ALL"] + line[1:])
                    elif line[1] == "":
                        pass
                    else:
                        writer.writerow(line)
            elif year == 2008:
                # Remove Header
                headerNum = 5
                for line in range(headerNum):
                    reader.next()
                # Fix Variables
                var = reader.next()
                header = var[:37]
                writer.writerow(header)
                headerNum = 3
                for line in range(headerNum):
                    reader.next()
                for line in reader:
                    if line[0] == "" and line[1] != "":
                        writer.writerow(["ALL"] + line[1:])
                    elif line[1] == "":
                        pass
                    else:
                        writer.writerow(line)                
            elif year == 2009:
                # Remove Header
                headerNum = 3
                for line in range(headerNum):
                    reader.next()
                # Fix Variables
                var = reader.next()
                header =  ["Location", "Income Bucket"] + var[2:]
                writer.writerow(header)
                headerNum = 2
                for line in range(headerNum):
                    reader.next()
                for line in reader:
                    if line[0] != "" and line[1] == "":
                        writer.writerow([line[0]] +  ["ALL"] + line[2:])
                    elif line[0] == "":
                        pass
                    else:
                        writer.writerow(line)                
            elif year == 2010:
                # Remove Header
                headerNum = 3
                for line in range(headerNum):
                    reader.next()
                # Fix Variables
                var = reader.next()
                header =  ["Location", "Income Bucket"] + var[2:]
                writer.writerow(header)
                headerNum = 2
                for line in range(headerNum):
                    reader.next()
                for line in reader:
                    if line[0] != "" and line[1] == "":
                        writer.writerow([line[0]] +  ["ALL"] + line[2:])
                    elif line[0] == "":
                        pass
                    else:
                        writer.writerow(line)                
            else:
                raise Exception



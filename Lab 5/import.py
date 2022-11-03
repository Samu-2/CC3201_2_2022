import psycopg2
import psycopg2.extras
import csv
import re

# GLOBAL VARS
_conn = None
_cur = None
_wanted_rows = [0, 1, 2, 3, 4, 8, 9, 23, 26]
"""
We want to get the columns: ID (0), Name (1), intelligence (2), strength (3), 
speed (4), bio name(8), alter egos(9), work (23), relatives (26)
"""
_naughty_chars = '.\'"\n'
_separator_chars = ",;|"

def findOrInsertMassive(table:str, data:dict, description:str) -> int:
    """
    Here data is a dict with the key being the column and the value being a list of values
    """
    print(" > Uploading massive data into " + table + " (" + description + ")")
    columns = list(data.keys())
    values = list(data.values())
    # First we check if that the len of all the values is the same
    assert len(set(map(len, values))) == 1, "ALL VALUES MUST HAVE THE SAME LENGTH"
    print("\t", len(values[0]), "rows to insert")
    print("\t Countdown 10 ", end="")
    count = 9
    for i in range(len(values[0])):
        if i % int(len(values[0])/9) == 0:
            print(count, end=" ")
            count -= 1
        dic = dict()
        for j in range(len(columns)):
            dic[columns[j]] = values[j][i]
        findOrInsert(table, dic)
    print("\n < Uploaded massive data into " + table + " (" + description + ") successfully")

def findOrInsert(table:str, data:dict) -> int:
    """
    Finds or inserts a row in the table, given the data as a dict
    where the keys are the columns and the values are the values
    """
    global _cur
    # First we check if the row exists
    a = "SELECT * FROM " + table + " WHERE "
    for key, value in data.items():
        if value == None: 
            value = "NULL"
            a += key + " IS " + value + " AND "
        else: 
            a += key + " = '" + value + "' AND "
    a += "TRUE LIMIT 1"
    _cur.execute(a)
    r = _cur.fetchone()
    if r:
        return r[0]
    else:
        # If it doesn't exist, we insert it
        a = "INSERT INTO " + table + " ("
        for key in data.keys():
            a += key + ", "
        a = a[:-2] + ") VALUES ('"
        for value in data.values():
            if value == None: 
                value = "NULL"
                a = a[:-1] + value + ", '"
            else: a += value + "', '"
        a = a[:-3] + ") RETURNING id"
        _cur.execute(a)
        r =_cur.fetchone()[0]
        _conn.commit()
        return r
    pass

def init_connection() -> None:
    global _conn, _cur
    print(" > Connecting . . . ")
    _conn = psycopg2.connect(host ="cc3201.dcc.uchile.cl", database ="cc3201", user ="cc3201", password ="j'<3_cc3201", port='5440')
    _cur = _conn.cursor()
    # _cur.execute("SET search_path TO superhero;")
    print(" < Connected!")

def fill_up_csv(csv:list, from_row:int, with_row) -> list:
    """
    Takes a (column, row, values) list and fills up null values of csv from_row with_row
    """
    print(" > Filling up csv columns " + str(from_row) + " with " + str(with_row))

    fill = []
    for a, b in zip(csv[from_row], csv[with_row]):
        if a == None:
            fill.append(b)
        else:
            fill.append(a)
    ret = csv[:from_row] + [fill] + csv[from_row+1:]

    print(" < Filled up csv")
    return ret

def separate_sub_values_csv(csv:list, in_rows:list) -> list:
    """
    takes a (column, row, values) list and returns a (column, row, values, sub values) list
    where sub values are separated by () brackets
    """
    print(" > Separating sub values")
    for i in range(len(csv)):
        if i in in_rows:
            for row in csv[i]:
                assert type(row) == list, "EXPECTED (column, row, values) INSTEAD {}".format(type(row))
    
    ret = []
    for i in range(len(csv)):
        if i in in_rows:
            ret_row = []
            for row in csv[i]:
                ret_value = []
                for value in row:
                    # Value is a str, we want to separate the sub values marked by ()
                    if value == None: # if the value is None, we just append it
                        ret_value.append(value)
                    elif (m := re.search(r"([^(]+)[ ]*\(([^)]+)\)", value)):
                        ret_value.append([m.group(1)] + [m.group(2)])
                    else:
                        ret_value.append([value])
                ret_row.append(ret_value)
            ret.append(ret_row)
        else:
            ret.append(csv[i])

    # We get rid of None values
    for i in range(len(ret)):
        if i in in_rows:
            for j in range(len(ret[i])):
                ret[i][j] = list(filter(lambda x: x != [], ret[i][j]))

    print(" < Separated sub values")
    return ret

def format_csv(csv:list, header:list, multiple:list, nulls:list, separators:str, remove:str) -> list:
    """
    takes a (column, row) list and returns a fully formatted list
    separators is a list of characters that will be used to separate the values
    in the rows that multiple indicates
    in this case, the row will be a list itself with the values separated
    remove is a list of characters that will be removed from the values
    """
    print(" > Formatting csv")
    # check integrity
    nrows = len(csv[0])
    ncolumns = len(csv)
    def check_integrity(csv:list) -> str:
        assert type(csv) == list, "EXPECTED (column, row) INSTEAD {}".format(type(csv))
        assert len(csv) == ncolumns, "EXPECTED {} COLUMNS INSTEAD {}".format(ncolumns, len(csv))    
        for i in range(len(csv)): 
            assert len(csv[i]) == nrows, "BAD NROW ON COLUMN {} GOT {} EXPECTED: {}".format(i, len(csv[i]), nrows)
        return "Integrity OK!"
    print("\t", check_integrity(csv), "CSV Dimensions: (", len(csv), len(csv[0]), ")")

    # Coding to ascii so no funny business happens
    to_ascii = [] # (column, row, values) 
    for column in csv:
        to_ascii_row = [] # (row, values)
        for row in column:
            row = row.encode('ascii', 'ignore').decode('ascii') 
            to_ascii_row.append(row)
        to_ascii.append(to_ascii_row)
    print("\t", check_integrity(to_ascii), "Recoded to ascii")

    # Separating values
    to_separate = [] # (column, row, values)
    i = 0
    for column in to_ascii:
        to_separate_row = [] # (row, values)
        for row in column:
            if (i not in multiple): 
                to_separate_row.append([row])
                continue
            # Sometimes there's separators inside brackets '()', we replace those with "\x00" so we deal with them later
            for char in separators:
                row = ''.join(m.replace(char, '\x00') if m.startswith('(') else m for m in re.split('(\([^)]+\))', row))
            row = re.split('[' + separators + ']', row)         # now we can split the values
            row = [value.replace('\x00', ',') for value in row] # now we can replace the "\x00" with commas
            to_separate_row.append(row)
        to_separate.append(to_separate_row)
        i+=1
    print("\t", check_integrity(to_separate), "Separated values")

    # Removing unwanted characters
    to_remove = [] # (column, row, values)
    for column in to_separate:
        to_remove_row = [] # (row, values)
        for row in column:
            for char in remove:
                row = [value.replace(char, '') for value in row]
            to_remove_row.append([value.strip(remove) for value in row])
        to_remove.append(to_remove_row)
    print("\t", check_integrity(to_remove), "Removed unwanted characters")
    
    # Sometimes, in rows there might be a value that is just a space, we remove those
    # but only if is not the only value in the row
    to_empty = [] # (column, row, values)
    for column in to_remove:
        to_empty_row = []
        for row in column:
            if len(row) == 1 and row[0] == '':
                to_empty_row.append([""])
            else:
                to_empty_row.append([value for value in row if value != ''])
        to_empty.append(to_empty_row)
    print("\t", check_integrity(to_empty), "Removed empty values")

    # We go trough the rows, and we strip and lower the values
    to_lower = [] # (column, row, values)
    for column in to_empty:
        to_lower_row = []
        for row in column:
            to_lower_row.append([value.strip().lower() for value in row])
        to_lower.append(to_lower_row)
    print("\t", check_integrity(to_lower), "Stripped and lowered values")

    # Now, we evaluate the columns, if every row has only one value, we make it a single value row
    single_value_column = [] # where all the rows are single value
    for i in range(len(to_lower)):
        if all(len(row) == 1 for row in to_lower[i]):
            single_value_column.append(i)

    # Check!
    if single_value_column + multiple != list(range(len(to_lower))):
        print("ERROR: single value columns + multiple columns != total columns")
        print("single value columns: ", single_value_column)
        print("multiple columns: ", multiple)
        print("total columns: ", list(range(len(to_lower))))
        assert False, "ERROR: single value columns + multiple columns != total columns"

    # Now we make the single value columns just the value rows
    single_value = [] # (column, row, values)
    for i in range(len(to_lower)):
        single_value_row = []
        if i in single_value_column:
            for row in to_lower[i]:
                single_value_row.append(row[0])
        else:
            single_value_row += to_lower[i]
        single_value.append(single_value_row)
    print("\t", check_integrity(single_value), "Single value columns")
    # Now we deal with the nulls
    to_null = [] # (column, row, values)
    for i in range(len(single_value)):
        to_null_row = []
        if i in single_value_column:
            for row in single_value[i]:
                if row in nulls:
                    to_null_row.append(None)
                else:
                    to_null_row.append(row)
        else:
            for row in single_value[i]:
                to_null_row.append([None if value in nulls else value for value in row])
        to_null.append(to_null_row)
    print("\t", check_integrity(to_null), "Nulls replaced")

    # Data finally processed
    formated = to_null

    # Characterizing the columns
    # We go trough the columns, and we check if they are numeric, lists, or strings
    # ignoring the nulls
    character = [] # (column, type)
    for column in formated:
        typeof = []
        if all(isinstance(value, list) for value in column if value is not None):
            typeof.append("list")
        elif all(value.isnumeric() for value in column if value is not None):
            typeof.append("numeric")
        else:
            typeof.append("str")
        # Now if there's a null, we point it as N/Type
        arenull = []
        if any(value is None for value in column):
            arenull.append("True")
        else:
            arenull.append("False")
        character.append(typeof + arenull)
    # Here we print a resume of the data
    print("\t", check_integrity(to_null), "Data processed & characterized")

    print("\t Column\tRows\tType\tnull\tDescription")
    for i in range(len(formated)):
        print("\t{}\t{}\t{}\t{}\t{}".format(i, len(formated[i]), character[i][0], character[i][1], header[i]))

    print("\t", check_integrity(formated), "CSV Dimensions: (", len(formated), len(formated[0]), ")")
    print(" < Formatted csv")
    return formated, character

def get_columns_csv(raw_csv:list, columns:list) -> list:
    """
    takes a (row, column) list and returns a list of the columns specified
    Returns a (column, row) list and the header of that list
    """
    print(" > Getting columns")
    print("\t Reatriving columns " + str(columns))
    header  = [raw_csv[0][i] for i in columns] # getting the header of the columns we want
    raw_csv = raw_csv[1:]                       # Data
    raw_csv = list(zip(*raw_csv))           # (row, column) -> (column, row)
    raw_csv = [raw_csv[i] for i in columns] # getting the columns we want
    
    print("\tRows\tFormer\tCurrent\tColumn Description")
    for i in range(len(columns)):
        print( "\t " + str(len(raw_csv[i])) + "\t" + str(columns[i]) + "\t" + str(i) + "\t" + str(header[i]))

    print(" < Got columns successful")
    return raw_csv, header

def read_csv(file:str)->list:
    print(" > Reading csv: " + file)
    with open(file) as csvfile:
        reader = csv.reader(csvfile, delimiter=',', quotechar='"')
        reader = list(reader)
        print("\t", len(reader), "rows reatrived")
        print(" < Read csv: " + file + " successful")
        return reader

def main()->None:
    raw_csv = read_csv('data.csv')
    stripped, header = get_columns_csv(raw_csv, _wanted_rows)
    formated, character = format_csv(stripped, header, [7, 8], ["null", "", "-"], _separator_chars, _naughty_chars)
    ok_data = separate_sub_values_csv(formated, [8])
    data    = fill_up_csv(ok_data, 5, 1)
    print("@ OK DATA!")
    # init_connection()
    
    INSERTING = False

    # We will insert heroes first
    hero_p = {"id": data[0], "name_p": data[5]}
    if INSERTING: findOrInsertMassive("s2_person", hero_p, "heroes as persons") 

    # We will insert now the relatives as persons
    rdata = list(zip(*data)) # (column, row) -> (row, column)
    # We select those where the list in the 8th column is not [None]
    rdata = [row for row in rdata if row[8] != [None]]
    relat = []
    for i in range(len(rdata)):
        for rel in rdata[i][8]:
            if rel is not None:
                if len(rel) > 1:
                    relat.append([rdata[i][0], rel[0], rdata[i][5], rdata[i][1], rel[1]])
                else:
                    relat.append([rdata[i][0], rel[0], rdata[i][5], rdata[i][1], None])
            else:
                print("ERROR: None in relatives ", i, rdata[i])
    relat = list(zip(*relat)) # (row, column) -> (column, row)
    rel = {"id": relat[0], "name_p": relat[1]}

    # sum the lenght of all the lists in the 8th column of data that aren't [None]
    # and we will insert that many persons
    sum = 0
    for i in range(len(data[8])):
        if data[8][i] != [None]:
            if data[8][i] == None:
                print("ERROR", i)
            sum += len(data[8][i])

    if INSERTING: findOrInsertMassive("s2_person", rel, "relatives as persons")

    # Completing now the hero table
    hero_h = {"id": data[0], "name_p": data[5], "name_h": data[1], "intelligence": data[2], "strength": data[3], "speed": data[4]}
    if INSERTING: findOrInsertMassive("s2_hero", hero_h, "heroes as heroes")

    # Completing now the work table
    rdata = list(zip(*data)) # (column, row) -> (row, column)
    # We select those where the list in the 7th column is not [None]
    rdata = [row for row in rdata if row[7] != [None]]
    work = []
    for i in range(len(rdata)):
        for rel in rdata[i][7]:
            if rel is not None:
                work.append([rdata[i][0], rdata[i][5], rdata[i][1], rel])
            else:
                print("ERROR: None in work ", i, rdata[i])
    work = list(zip(*work)) # (row, column) -> (column, row)
    hero_w = {"id": work[0], "name_p": work[1], "name_h": work[2], "name_w": work[3]}
    if INSERTING: findOrInsertMassive("s2_work", hero_w, "heroes as work")

    # Completing now the alter ego table
    rdata = list(zip(*data)) # (column, row) -> (row, column)
    # We will now just join the lists in the 6th column where it is not 'no alter egos found'
    rdata = [row for row in rdata if row[6] != 'no alter egos found']
    rdata = list(zip(*rdata)) # (row, column) -> (column, row)
    hero_a = {"id": rdata[0], "name_p": rdata[5], "name_h": rdata[1], "name_a": rdata[6]}
    if INSERTING: findOrInsertMassive("s2_alter", hero_a, "heroes as alter ego")

    # Completing now the relations table
    # thankfully the relations are already in the right format as relat
    hero_r = {"id": relat[0], "name_p": relat[1], "name_h": relat[3], "name_ph": relat[2], "relation": relat[4]}
    findOrInsertMassive("s2_related", hero_r, "heroes relations")




if __name__ == "__main__":
    main()

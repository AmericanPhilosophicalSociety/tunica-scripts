def create_filename(num):
    num_str = str(num)
    while len(num_str) < 3:
        num_str = "0" + num_str
    return f"f{num_str}"

def run_program():
    page_num = 204
    for i in range(page_num):
        name = create_filename(i)
        output_file = open(f'blank-txt-files/{page_num}/{name}.txt', 'w', encoding="utf-8")
        output_file.write("No data to display")
        output_file.close() 

if __name__ == '__main__':
    run_program()
"""
input:
output:
requires directories: linguistic, text
"""

from bs4 import BeautifulSoup

notebook = 12
file_name = "notebook-12-html.xml"

# read in file to Beautiful Soup
def extract_pages():
    file = open(file_name, "r", encoding="utf-8")
    contents = file.read()
    soup = BeautifulSoup(contents, 'xml')
    
    print(soup)
    
    pages = soup.find_all('div', class_="page")
    pages_dict = {}
    
    # set arbitrary values for first time through loop
    prev_num_pre = -1
    prev_num_processed = -1
    
    for page in pages:
        # page_num = page['id']
        result = process_page_num(page['id'], prev_num_pre, prev_num_processed)
        prev_num_pre = result[0]
        prev_num_processed = result[1]
        print(f"{prev_num_pre} -> {prev_num_processed}")
        
        # add page html to dict with processed page num as key
        pages_dict[prev_num_processed] = page
        
    return pages_dict

# takes as input num to be processed and previous num (both preprocessed and processed forms)
# outputs list with preprocessed and processed number
def process_page_num(num_str, prev_num_unprocessed, prev_num_processed):
    num_pre = int(num_str[:3])
    if num_str == "000A":
        return [num_pre, 0]
    elif num_str == "000B":
        return [num_pre, 1]
    elif num_str == "000C":
        return [num_pre, 2]
    elif num_str == "000D":
        return [num_pre, 3]
    # special logic to deal with inconsistent page numbering in notebook 6
    elif notebook == 6 and num_pre == 49:
        return [num_pre, 50]
    elif notebook == 12 and num_str == "001":
        return [num_pre, 2]
    else:
        pages_to_add = num_pre - prev_num_unprocessed
        if pages_to_add == 0:
            print(f"Manually check page: {num_str}")
        result = prev_num_processed + pages_to_add
        return [num_pre, result]

def page_num_to_file_name(num_int):
    num_str = str(num_int)
    while len(num_str) < 3:
        num_str = "0" + num_str
    return f"f{num_str}"

def output_file(contents, name, dir):
    if contents and contents != "None":
        header = f"""
            <tei-text data-xmlns="http://www.tei-c.org/ns/1.0" xml:id="{dir}" id="{dir}" data-origname="text"><tei-body data-origname="body"><tei-div data-origname="div"><tei-pb facs="#{name}" data-origname="pb" data-empty=""></tei-pb>
        """
        footer = """
            </tei-div></tei-body></tei-text>
        """
        contents = f"{header}\n{contents}\n{footer}"
        output_file = open(f'{dir}/{name}.html', 'w', encoding="utf-8")
        output_file.write(contents)
        output_file.close()

def output_files(pages_dict):
    for page_num, div in pages_dict.items():
        file_name = page_num_to_file_name(page_num)
        
        text = str(div.find('div', class_="text"))
        output_file(text, file_name, "text")
        
        linguistic = str(div.find('div', class_="linguistic"))
        output_file(linguistic, file_name, "linguistic")

def run_program():
    pages_dict = extract_pages()
    output_files(pages_dict)

if __name__ == '__main__':
    run_program()
    
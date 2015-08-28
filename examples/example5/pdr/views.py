#!/usr/bin/env python
# -*- coding: utf-8 -*-

from django.shortcuts import render_to_response
from urllib2 import Request, urlopen
from xml.etree import cElementTree as ET
import itertools

def home(request):
    pathway_number = request.GET.get("fetch", False)
    try:
        r = request.GET.get("times", 1)
    except:
        r = 1

    if pathway_number:
        compounds, reactions = get_pathway("ec", pathway_number)
    else:
        compounds = [
            {'id': '1', 'label': 'label 1', 'position': [200, 200], 'size': [40, 20],	'shape': 'square', 'color': ['red', 'blue'], },
            {'id': '2', 'label': 'label 2', 'position': [100, 100], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '3', 'label': 'label 3', 'position': [300, 100], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '4', 'label': 'label 4', 'position': [200, 100], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '5', 'label': 'label 5', 'position': [100, 200], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '6', 'label': 'label 6', 'position': [300, 200], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '7', 'label': 'label 7', 'position': [100, 300], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '8', 'label': 'label 8', 'position': [200, 300], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
            {'id': '9', 'label': 'label 9', 'position': [300, 300], 'size': [40, 20],	'shape': 'square', 'color': ['#ad2', 'blue'], },
        ]
        reactions = [
            {'id': '1', 'label': 'label 1', 'compound1_id': '1', 'compound2_id': '2', 'type': 'reversible' },
            {'id': '2', 'label': 'label 2', 'compound1_id': '1', 'compound2_id': '3', 'type': 'reversible' },
            {'id': '3', 'label': 'label 3', 'compound1_id': '1', 'compound2_id': '4', 'type': 'reversible' },
            {'id': '4', 'label': 'label 4', 'compound1_id': '1', 'compound2_id': '5', 'type': 'reversible' },
            {'id': '5', 'label': 'label 5', 'compound1_id': '1', 'compound2_id': '6', 'type': 'reversible' },
            {'id': '6', 'label': 'label 6', 'compound1_id': '1', 'compound2_id': '7', 'type': 'reversible' },
            {'id': '7', 'label': 'label 7', 'compound1_id': '1', 'compound2_id': '8', 'type': 'reversible' },
            {'id': '8', 'label': 'label 8', 'compound1_id': '1', 'compound2_id': '9', 'type': 'reversible' },
        ]
    data = {"compounds": compounds,
            "reactions": reactions,
            "times": "x" * int(r)}
    return render_to_response("index.html", data)


def get_pathway(org, pathway_number):
    hdrs = { 'User-Agent': "Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11" }
    url_address = "http://rest.kegg.jp/get/%s%s/kgml" % (org, str(pathway_number).zfill(5))
    url2 = Request(url_address, headers=hdrs)
    xml_txt = urlopen(url2).read()
    tree = ET.fromstring(xml_txt)
    compounds = []
    reactions = []
    rel_id = 10000

    for node in tree.getchildren():
        if node.tag == "entry":
            id_code = node.get("id", 0)
            label = node.get("name", "Unknown")
            type = node.get("type", "Unknown")
            for child in node.getchildren():
                graphic_name = node.get("name", "Unknown")[0:30]
                x = int(child.attrib.get("x", 0))
                y = int(child.attrib.get("y", 0))
                w = int(child.attrib.get("width", 0))
                h = int(child.attrib.get("height", 0))
                width = node.get("width", 20)
                height = node.get("height", 20)
                color1, color2 = node.get("fbcolor", "#ddd"), node.get("bgcolor", "#BFFFBF")
                compounds.append({'label': label.split(":")[1], 'id': id_code, 'position': [x, y], 'size': [w, h], 'type': type, 'color': [color1, color2]})
        elif node.tag == "reaction":
            id_code = node.get("id", 0)
            reaction_type = node.get("type", "irreversible")
            product, substrate = [], []
            for child in node.getchildren():
                if child.tag == "product":
                    product.append(child)
                elif child.tag == "substrate":
                    substrate.append(child)
            for p, s in itertools.product(product, substrate):
                reactions.append({'id': id_code,
                                  'compound1_id': p.get("id"),
                                  'compound2_id': id_code,
                                  'type': reaction_type,
                                  })
                reactions.append({'id': id_code,
                                  'compound1_id': id_code,
                                  'compound2_id': s.get("id"),
                                  'type': reaction_type,
                                  })
        elif node.tag == "relation": # and node.get("type") == "maplink":
            rel_id += 1
            subtype = node.getchildren()[0]
            reactions.append({'id': rel_id,
                              'compound1_id': node.get("entry1"),
                              'compound2_id': subtype.get("value"),
                              'type': "relation_",
                              })
            reactions.append({'id': rel_id,
                              'compound1_id': subtype.get("value"),
                              'compound2_id': node.get("entry2"),
                              'type': "relation_",
                              })
    return compounds, reactions



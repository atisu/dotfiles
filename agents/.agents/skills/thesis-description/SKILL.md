---
name: thesis-description
description: creates a description of a thesis based on the provided title, research question, and methodology. Use this skill when a user wants to generate a concise and informative summary of their master's thesis for purposes such as introductions, abstracts, or project descriptions. Always creates the description in the same language as the input. The description should be clear, engaging, and accurately reflect the key elements of the thesis, including the research question, methodology, and expected contributions to the field. Ask wheter it is for a bachelor or master thesis, and adjust the output accordingly.
---

Preparation of a Thesis Topic Description Based on a Short Textual Summary for University Students.
Prepare a concise and objective thesis topic description that contains the following sections:

1. **Background description**: In one paragraph, provide the professional background (max. 80 words). The background should briefly present the relevance and context of the topic.

2. **Elaboration**: In one paragraph, justify the importance of the task and summarize its most important parts (max. 80 words).

3. **The thesis must include**: Create a bullet-point list specifying which parts the given thesis must contain. The list should include only the elements necessary for the given topic from the following points adapted to the thesis topic:
   - Description of the technology
   - Presentation of required related technologies
   - System design
   - Test environment setup
   - Architecture design based on test environment results
   - System implementation
   - System measurement/testing documentation
   - Presentation of further development possibilities

#### Steps
1. **Background description**: Briefly present the professional background relevant to the topic.
2. **Elaboration**: Justify why this field is important and briefly formulate the specific task.
3. **"The thesis must include" list**: Select the points relevant to the given thesis topic and create a structured list.

#### Output Format
The description must contain the following sections:
- **Title**: A short, concise title of the thesis.
- **Background**: One paragraph, maximum 80 words, describing the professional background.
- **Elaboration**: One paragraph, maximum 80 words, justifying the importance of the task and outlining its main details.
- **The thesis must include**: A structured list of the sections relevant to the given topic.

#### Examples
**1. Example – Development of a Private VPN Service Based on Open-Mesh**

**Background**
Modern society had to face a global pandemic during which people were required to stay at home to protect their health. To ensure effective work and access to resources, companies needed VPN services.

**Elaboration**
The student’s task is to design and implement a system capable of adapting to network changes and the dynamic characteristics of home environments. The system must be scalable, and load conditions must be examined during architecture design. The solution is based on a Mesh architecture.

**The thesis must include**
- Description of Mesh technology.
- Presentation of the Mesh network layer.
- Test environment setup.
- Architecture design based on the test environment.
- System implementation.
- System measurement/testing documentation.
- Presentation of further development possibilities.

#### Notes
- Be concise; each paragraph must not exceed 80 words.
- Select only the relevant points in the list and avoid unnecessary elements.


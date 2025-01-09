# CreatingTrivia

## Introduction

In this project, I explore the ability of LLMs to create unique content that could serve as the basis for games or educational apps. I use Google Gemini's API in Jupyter notebook to create a Pandas data frame consisting of trivia questions, answers, along with a topic and difficultly level. I then analyze the distribution of trivia questions created by the LLM using Power BI. I use MySql to clean the data, removing questions and answers that are duplicated many times, creating a cleaned database of trivia questions. Finally, I import the cleaned data back into Power BI to reanalyze it. 

## Process

### Step 1: Using Google Gemini/Python to generate trivia questions 

The Jupyter Notebook code to generate trivia questions works as follows: 
 1. Connect to Google Gemini API
 2. Randomly choose topic from list: "geography", "history", "science", "literature", "music", "sports"
 3. Randomly choose difficulty level from list: "easy", "medium", "hard"
 4. Send request to Gemini using API: "Generate a {difficulty} level unique trivia question about {topic}, along with a concise answer."
 5. Parse Gemini's response into question and answer parts
 6. Append question, answer, topic, and difficulty level for each question generated to the dataframe

To avoid overloading the API, I created batches of 100 questions at a time, with a 15 second delay between each request. I then appended the original dataframe with the new batch of 100 questions, so that each time I ran the Jupyter Notebook cell, the trivia dataframe would grow by 100 questions. I had to do this about 35 times to create the full dataframe with ~ 3500 questions. 

At first glance I noticed that for a significant number of questions, the API didn't return any data (in this case, my code returns "No question generated" and "No answer provided" and appends the dataframe with that information). I also notice that a number of questions are repeated, likely because the LLM doesn't store in memory what its past responses were. So at first glance, I can see that we get many repeated questions, but also many unique questions.

### Step 2: Using Power BI to analyze the raw data

#### First Dashboard: Pie Charts of Questions by Topics and Questions Generated/Not Generated: 

![image](https://github.com/user-attachments/assets/39feb723-404b-4b19-b32b-942e112b8bdd)

The top pie chart shows the distribution of questions by topic. We can see that the distribution is fairly uniform, with about 16-17% of total questions per topic. This is a result we would expect from random selection according to the Law of large numbers (the sample distribution converges to true distribution as sample size increases). The distribution looks similar when filtered by difficultly level. 

The pie chart on bottom shows that 36% of the data is "No question generated" - meaning the API didn't provide a response - while 64% of the data should be actual trivia questions, although not all of those trivia questions are unique. Whether questions were generated or not seems heavily dependent on difficulty level and topic. For example, all hard science questions returned responses, while 82% of easy sports questions returned no data. We can see a clear difference in the proportion of questions generated for "hard" vs "easy" difficulty levels, suggesting that the LLM does better at generating hard questions than easy ones: 

![image](https://github.com/user-attachments/assets/9db2419d-a402-4804-a639-f26969455351)

![image](https://github.com/user-attachments/assets/6bcde8c1-eb18-44a0-863d-81c1623a740a)


#### Second Dashboard: Bar Charts of Questions/Answers most repeated

By far the most commonly repeated Quetion/Answer pair is "What is the largest planet in our solar system?/Jupiter", which was repeated 157 times. The second most commonly repeated was "What fundamental force is responsible for the radioactive decay of atomic nuclei/The weak nuclear force." That question was repeated 70 times, while the answer was repeated 83 times, suggesting that the LLM modified the wording of the question in some instances. 

![image](https://github.com/user-attachments/assets/6f37f8a5-3986-4b80-83ed-c3b6007436d1)


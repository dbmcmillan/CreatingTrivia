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

### Step 3: Using MySql to Clean Data and Delete Duplicates

#### Deleting Duplicates

The main goal of the project is to delete all the repeated questions and be left with a core of unique trivia questions of varying difficulty levels and topics. I decided to use MySql for the data cleaning phase of the project. First I loaded the csv file created by the Jupyter Notebook script into MySql as a database and table called "trivia". To delete all the duplicate questions and answers, while leaving the first version of the question untouched, I joined the table on itself on different rows where either the questions were identical, the answers were identical, or both. I deleted all rows in which the id in the original table was greater than the id in the joined table. This would delete all but the first row in the original table in which duplicate questions or answers were found. I then noticed a few question/answer pairs that were approximate but not exact matches, and I deleted those individually. 

All this cut the number of trivia questions from 3616 down to 1055. There are probably still a few duplicates in that group of questions that I didn't catch upon first glance, but those can be deleted individually in the csv file when they are found. I'm quite confident that the number of true duplicates is minimal at this point. 

#### Dashboards to show the effects of data cleaning

I reuploaded the cleaned data into Power BI to re-run the same visualizations and see the effects. Notice that our new trivia data is skewed toward literature and away from geography, meaning that the LLM did the best job creating unique literature questions and the worst job creating unique geography questions. That's likely unsurprising given that the body of literature is often part of an LLM's training set. We can also see that there is no longer any question or answer with a count greater than one (so no exactly repeated questions at least). 
![image](https://github.com/user-attachments/assets/b0cc3310-eb98-48c6-b109-7543710774c0)

Although the first 6 questions in the dashboard all start the same ("In what year did a major..."), upon inspection they all ask different things. The LLM has a habit of beginning different questions the same way ("In which lesser-known work...", "What fundamental physical constant...", "What seemingly insignificant historical event...", etc). It's almost as if the LLM had a template for creating trivia question. 

The following visualization shows that the data cleaning process eliminated many "easy" and "medium" difficulty questions, while a lot of "hard" questions remained. That suggests that the LLM does a better job generating unique hard questions than unique easy questions (or that the harder the questions get, the more unique they get). The graphic on the right shows the counts of remaining questions by topic post-cleaning. As already stated, "literature" is the most common remaining category and "geography" the least common. 

![image](https://github.com/user-attachments/assets/91f30a5a-56a9-46d7-81a2-b05da584a0c2)

## Concluding Thoughts and Next Steps

The purpose of this project is to explore the uses of LLMs in generating unique and usable content, in this case questions that could potentially form the basis of a trivia game. I used a free LLM (Google Gemini) and connected to it through an API in Jupyter Notebook, which is inherently limiting since the API imposes restrictions on the amount of data that can be pulled. As a result, I got a lot of requests without responses, and a great number of duplicate questions.

To follow up on this project, I would like to explore the paid options and see which ones could allow for a large amount of content generation in one request. That would likely reduce the number of duplicate questions greatly, since the LLM wouldn't "forget" prior provided question/answer pairs. If each row in the database requires roughly 100-200 tokens to generate, then creating 5000 unique trivia questions would require about 1 to 2 million tokens. 

Additionally, an LLM could also be used to double check its own work (or the work of another LLM). I got some unusual question/answer pairs in my data. For example: 
** Question: "Which two golfers have won the grand slam (all 4 majors) in both men's golf and women's golf?" Answer: "None" (This one is my personal favorite)
** Question: "Which letter is not contained in the names of any of the planets in our solar system?" Answer: "J" (But of course "Jupiter" starts with a "J")

Since LLMs can make mistakes, using other LLMs to check their work and give feedback could be an intelligent way to remove factual errors from an LLM's provided content. My next steps in this project, as I expand upon this concept, will be to use a paid LLM to generate trivia data and then a different LLM to check its work line by line, and potentially to do the job of removing duplicates. Removing similar, but not identical, lines could be done much more effectively by an LLM than a human in a big data set. As far as I know there's no way to algorithmically remove approximately similar content, but an LLM could quickly read all the data and judge which rows are similar enough to be considered effectively duplicates. 

Lastly, though the content generation here wasn't perfect, it gave me much greater appreciation of the scale of potential uses of LLMs and AI in general. 



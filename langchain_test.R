library(reticulate)

source("params.R")

llms = import("langchain_community.llms")
embeddings_import = import("langchain_community.embeddings")
vectorstores = import("langchain_community.vectorstores")
chains = import("langchain.chains")

llm = llms$Ollama(model = model, temperature = 0)
embeddings = embeddings_import$OllamaEmbeddings(model = model)
vectordb = vectorstores$Chroma(persist_directory=chromadb_file,
                  embedding_function=embeddings)
qa_chain = chains$RetrievalQA$from_chain_type(llm, retriever=vectordb$as_retriever())

# By default it does:
#   sim_docs = vectordb$similarity_search(query)
# But this could be interesting
#   mm_docs = vectordb$max_marginal_relevance_search(query, k = 4, fetch_k = 10L)

qa_chain$invoke("Which treatment has the least side effects for COPD?")
